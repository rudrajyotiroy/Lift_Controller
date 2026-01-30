`ifndef MULTI_LIFT_CONTROLLER_DRIVER
`define MULTI_LIFT_CONTROLLER_DRIVER

class multi_lift_controller_driver #(parameter N_FLOORS = `NUM_FLOORS, parameter N_LIFTS = 10) extends uvm_driver #(multi_lift_controller_cfg #(N_FLOORS, N_LIFTS));
    // Virtual interface
    virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS) vif;

    // Analysis ports for each lift's scoreboard
    uvm_analysis_port #(lift_controller_seq_item) lift_sb_ports[N_LIFTS];

    // Track last seen floor for each lift to match RTL arbiter behavior
    int last_floor[N_LIFTS];

    `uvm_component_utils(multi_lift_controller_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        for (int i = 0; i < N_LIFTS; i++) begin
            lift_sb_ports[i] = new($sformatf("lift_sb_ports_%0d", i), this);
            last_floor[i] = 0; // Default to floor 1 (index 0)
        end
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS))::get(this, "", "multi_lift_controller_vif", vif)) begin
            `uvm_fatal(get_full_name(), "Virtual interface not found")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        vif.up_rqst <= 0;
        vif.dn_rqst <= 0;
        for (int i=0; i<N_LIFTS; i++) vif.flr_rqst[i] <= 0;
        vif.force_open <= 0;

        wait(!vif.reset);
        fork
            track_last_floor();
            begin
                forever begin
                    seq_item_port.get_next_item(req);
                    `uvm_info(get_full_name(), $sformatf("Driving multi-lift transaction: %s", req.convert2string()), UVM_LOW)
                    drive_transfer(req);
                    seq_item_port.item_done();
                end
            end
        join
    endtask

    task track_last_floor();
        forever begin
            @(posedge vif.clk);
            for (int i = 0; i < N_LIFTS; i++) begin
                if (vif.floor_sense[i] != 0) begin
                    for (int j = 0; j < N_FLOORS; j++) begin
                        if (vif.floor_sense[i][j]) begin
                            last_floor[i] = j;
                            break;
                        end
                    end
                end
            end
        end
    endtask

    task drive_transfer(multi_lift_controller_cfg #(N_FLOORS, N_LIFTS) tr);
        int target_lift = -1;

        if (tr.req_type == UP || tr.req_type == DN) begin
            target_lift = predict_best_lift(tr.floor, tr.req_type);
            if (tr.req_type == UP) vif.up_rqst = (1 << (tr.floor-1));
            else vif.dn_rqst = (1 << (tr.floor-1));

            // Send to scoreboard
            if (target_lift != -1) begin
                send_to_sb(target_lift, tr.floor, tr.req_type);
            end

            repeat(5) @(posedge vif.clk);
            vif.up_rqst = 0;
            vif.dn_rqst = 0;
        end else if (tr.req_type == STOP) begin
            target_lift = tr.lift_id;
            vif.flr_rqst[target_lift] = (1 << (tr.floor-1));
            send_to_sb(target_lift, tr.floor, tr.req_type);
            repeat(5) @(posedge vif.clk);
            vif.flr_rqst[target_lift] = 0;
        end
    endtask

    function int predict_best_lift(int floor, lift_request req_type);
        int best_lift = -1;
        int min_dist = 1000;
        int f = floor - 1;

        for (int i = 0; i < N_LIFTS; i++) begin
            int cur_f = last_floor[i];
            int dist;
            bit eligible = 0;

            if (req_type == UP) begin
                if (vif.motion[i] && vif.direction[i] && cur_f <= f) begin
                    dist = f - cur_f;
                    eligible = 1;
                end else if (!vif.motion[i]) begin
                    dist = (f > cur_f) ? (f - cur_f) : (cur_f - f);
                    dist = dist + N_FLOORS;
                    eligible = 1;
                end
            end else if (req_type == DN) begin
                if (vif.motion[i] && !vif.direction[i] && cur_f >= f) begin
                    dist = cur_f - f;
                    eligible = 1;
                end else if (!vif.motion[i]) begin
                    dist = (f > cur_f) ? (f - cur_f) : (cur_f - f);
                    dist = dist + N_FLOORS;
                    eligible = 1;
                end
            end

            if (eligible && dist < min_dist) begin
                min_dist = dist;
                best_lift = i;
            end
        end
        if (best_lift == -1) best_lift = 0; // Fallback to match RTL arbiter
        return best_lift;
    endfunction

    task send_to_sb(int lift_id, int floor, lift_request req_type);
        lift_controller_seq_item tr_to_sb = new();
        if (req_type == STOP) begin
            tr_to_sb.door = DOOR_OPEN;
            tr_to_sb.floor = floor;
            tr_to_sb.dir = DIR_DN; // ignored for STOP
            lift_sb_ports[lift_id].write(tr_to_sb);
        end else begin
            tr_to_sb.door = DOOR_OPEN;
            tr_to_sb.floor = floor;
            tr_to_sb.dir = (req_type == UP) ? DIR_UP : DIR_DN;
            lift_sb_ports[lift_id].write(tr_to_sb);
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
