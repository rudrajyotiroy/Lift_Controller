`ifndef MULTI_LIFT_CONTROLLER_DRIVER
`define MULTI_LIFT_CONTROLLER_DRIVER

class multi_lift_controller_driver #(parameter N_FLOORS = `NUM_FLOORS, parameter N_LIFTS = 10) extends uvm_driver #(multi_lift_controller_cfg #(N_FLOORS, N_LIFTS));
    // Global virtual interface
    virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS) vif;

    // Individual lift virtual interfaces for reactive scoreboard feeding
    virtual lift_controller_if #(N_FLOORS) lift_vifs[N_LIFTS];

    // Analysis ports for each lift's scoreboard
    uvm_analysis_port #(lift_controller_seq_item) lift_sb_ports[N_LIFTS];

    `uvm_component_utils(multi_lift_controller_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        for (int i = 0; i < N_LIFTS; i++) begin
            lift_sb_ports[i] = new($sformatf("lift_sb_ports_%0d", i), this);
        end
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS))::get(this, "", "multi_lift_controller_vif", vif)) begin
            `uvm_fatal(get_full_name(), "Global virtual interface not found")
        end
        for (int i = 0; i < N_LIFTS; i++) begin
            if (!uvm_config_db#(virtual lift_controller_if #(N_FLOORS))::get(this, "", $sformatf("lift_vif_%0d", i), lift_vifs[i])) begin
                `uvm_fatal(get_full_name(), $sformatf("Lift interface %0d not found", i))
            end
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        // Initialize
        vif.up_rqst <= 0;
        vif.dn_rqst <= 0;
        for (int i=0; i<N_LIFTS; i++) vif.flr_rqst[i] <= 0;
        vif.force_open <= 0;

        wait(!vif.reset);

        // Start reactive monitoring threads for each lift
        for (int i = 0; i < N_LIFTS; i++) begin
            fork
                int id = i;
                monitor_lift_requests(id);
            join_none
        end

        // Main request driving loop
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_full_name(), $sformatf("Driving multi-lift request: %s", req.convert2string()), UVM_LOW)
            drive_transfer(req);
            seq_item_port.item_done();
        end
    endtask

    // Reactive task to feed scoreboards based on what each lift actually sees
    task monitor_lift_requests(int id);
        forever begin
            @(posedge lift_vifs[id].clk);
            if (lift_vifs[id].up_rqst != 0) begin
                int f = ENCODER #(N_FLOORS)::ONE_HOT_TO_DECIMAL(lift_vifs[id].up_rqst);
                `uvm_info(get_full_name(), $sformatf("Lift %0d received UP request at floor %0d (reactive)", id, f), UVM_HIGH)
                send_to_sb(id, f, UP);
                while (lift_vifs[id].up_rqst != 0) @(posedge lift_vifs[id].clk);
            end
            if (lift_vifs[id].dn_rqst != 0) begin
                int f = ENCODER #(N_FLOORS)::ONE_HOT_TO_DECIMAL(lift_vifs[id].dn_rqst);
                `uvm_info(get_full_name(), $sformatf("Lift %0d received DN request at floor %0d (reactive)", id, f), UVM_HIGH)
                send_to_sb(id, f, DN);
                while (lift_vifs[id].dn_rqst != 0) @(posedge lift_vifs[id].clk);
            end
            if (lift_vifs[id].flr_rqst != 0) begin
                int f = ENCODER #(N_FLOORS)::ONE_HOT_TO_DECIMAL(lift_vifs[id].flr_rqst);
                `uvm_info(get_full_name(), $sformatf("Lift %0d received STOP request at floor %0d (reactive)", id, f), UVM_HIGH)
                send_to_sb(id, f, STOP);
                while (lift_vifs[id].flr_rqst != 0) @(posedge lift_vifs[id].clk);
            end
        end
    endtask

    task drive_transfer(multi_lift_controller_cfg #(N_FLOORS, N_LIFTS) tr);
        if (tr.req_type == UP) begin
            vif.up_rqst = (1 << (tr.floor-1));
            repeat(5) @(posedge vif.clk);
            vif.up_rqst = 0;
        end else if (tr.req_type == DN) begin
            vif.dn_rqst = (1 << (tr.floor-1));
            repeat(5) @(posedge vif.clk);
            vif.dn_rqst = 0;
        end else if (tr.req_type == STOP) begin
            vif.flr_rqst[tr.lift_id] = (1 << (tr.floor-1));
            repeat(5) @(posedge vif.clk);
            vif.flr_rqst[tr.lift_id] = 0;
        end
    endtask

    // Utility to send expected transactions to the appropriate lift scoreboard
    task send_to_sb(int lift_id, int floor, lift_request req_type);
        lift_controller_seq_item tr_to_sb = new();
        if (req_type == STOP) begin
            tr_to_sb.door = DOOR_OPEN;
            tr_to_sb.floor = floor;
            tr_to_sb.dir = DIR_DN; // ignored for STOP
            lift_sb_ports[lift_id].write(tr_to_sb);
        end else begin
            // UP/DN requests expect a stop (OPEN) and then a departure (CLOSED) in that direction
            tr_to_sb.door = DOOR_OPEN;
            tr_to_sb.floor = floor;
            tr_to_sb.dir = (req_type == UP) ? DIR_UP : DIR_DN;
            lift_sb_ports[lift_id].write(tr_to_sb);

            // Minimal delay to ensure sequential processing in scoreboard
            #1;

            tr_to_sb = new();
            tr_to_sb.door = DOOR_CLOSED;
            tr_to_sb.floor = floor;
            tr_to_sb.dir = (req_type == UP) ? DIR_UP : DIR_DN;
            lift_sb_ports[lift_id].write(tr_to_sb);
        end
    endtask

endclass

`endif
