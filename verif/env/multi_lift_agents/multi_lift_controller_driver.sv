`ifndef MULTI_LIFT_CONTROLLER_DRIVER
`define MULTI_LIFT_CONTROLLER_DRIVER

class multi_lift_controller_driver #(parameter N_FLOORS = `NUM_FLOORS, parameter N_LIFTS = 10) extends uvm_driver #(person_journey_item);
    // Global virtual interface
    virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS) vif;

    // Individual lift virtual interfaces
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

        wait(!vif.reset);

        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_full_name(), $sformatf("New journey request for Person %0d: %d -> %d", req.person_id, req.src_floor, req.dest_floor), UVM_LOW)
            fork
                automatic person_journey_item journey = req;
                begin
                    handle_journey(journey);
                    // We don't call item_done() here if we want the sequence to wait.
                    // Actually, UVM sequences wait on item_done if they use `uvm_do`.
                    // But if we have parallel sequences, we should manage them carefully.
                    seq_item_port.item_done();
                end
            join_none
        end
    endtask

    task handle_journey(person_journey_item journey);
        hall_panel h_panel = hall_panel::type_id::create("h_panel");
        car_panel c_panel = car_panel::type_id::create("c_panel");
        lift_request req_type = (journey.dest_floor > journey.src_floor) ? UP : DN;
        int boarded_lift = -1;

        h_panel.vif = vif;
        journey.request_time = $realtime;

        // 1. Press global button
        `uvm_info(get_full_name(), $sformatf("Person %0d pressing %s button at Floor %d", journey.person_id, req_type.name(), journey.src_floor), UVM_MEDIUM)
        h_panel.press_button(journey.src_floor, req_type);

        // Note: Global requests are handled by the arbiter.
        // We don't know yet which lift will pick it up.
        // Once a lift arrives, we'll "press" its internal buttons.

        // 2. Wait for any lift to arrive
        while (boarded_lift == -1) begin
            for (int i = 0; i < N_LIFTS; i++) begin
                if (lift_vifs[i].door_open &&
                    lift_vifs[i].floor_sense == (1 << (journey.src_floor-1)) &&
                    ((req_type == UP && lift_vifs[i].direction == 1'b1) ||
                     (req_type == DN && lift_vifs[i].direction == 1'b0))) begin
                    boarded_lift = i;
                    break;
                end
            end
            if (boarded_lift == -1) @(posedge vif.clk);
        end

        journey.boarded_lift_id = boarded_lift;
        journey.boarding_time = $realtime;
        $display("[PERSON_JOURNEY] Person %0d chose elevator %0d at Floor %0d", journey.person_id, boarded_lift, journey.src_floor);

        // Scoreboard Update for Hall Request:
        // Now we know which lift picked it up, so we send the expected transaction to its SB
        send_sb_hall_request(boarded_lift, journey.src_floor, req_type);

        // 3. OOP Connection Shift: Switch to car panel
        c_panel.vif = lift_vifs[boarded_lift];
        c_panel.lift_id = boarded_lift;

        // 4. Send STOP request to destination
        `uvm_info(get_full_name(), $sformatf("Person %0d inside Lift %0d pressing button for Floor %d", journey.person_id, boarded_lift, journey.dest_floor), UVM_MEDIUM)

        // Scoreboard Update for Car Request:
        send_sb_car_request(boarded_lift, journey.dest_floor);

        c_panel.press_button(journey.dest_floor, STOP);

        // 5. Wait for destination arrival
        while (!(lift_vifs[boarded_lift].door_open &&
                 lift_vifs[boarded_lift].floor_sense == (1 << (journey.dest_floor-1)))) begin
            @(posedge lift_vifs[boarded_lift].clk);
        end

        journey.deboarding_time = $realtime;
        `uvm_info(get_full_name(), $sformatf("Person %0d arrived at Floor %d in Lift %0d", journey.person_id, journey.dest_floor, boarded_lift), UVM_LOW)
    endtask

    task send_sb_hall_request(int lift_id, int floor, lift_request req_type);
        lift_controller_seq_item tr = new();
        tr.floor = floor;
        tr.dir = (req_type == UP) ? DIR_UP : DIR_DN;
        tr.door = DOOR_OPEN;
        lift_sb_ports[lift_id].write(tr);
        #1;
        tr = new();
        tr.floor = floor;
        tr.dir = (req_type == UP) ? DIR_UP : DIR_DN;
        tr.door = DOOR_CLOSED;
        lift_sb_ports[lift_id].write(tr);
    endtask

    task send_sb_car_request(int lift_id, int floor);
        lift_controller_seq_item tr = new();
        tr.floor = floor;
        tr.dir = DIR_DN; // Ignored for STOP
        tr.door = DOOR_OPEN;
        lift_sb_ports[lift_id].write(tr);
    endtask

endclass

`endif
