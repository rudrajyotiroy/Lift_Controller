`ifndef MULTI_LIFT_TRAFFIC_SEQUENCE
`define MULTI_LIFT_TRAFFIC_SEQUENCE

// OOP representation of a person's behavior and their "connection" to a lift
class person_session extends uvm_object;
    int origin_floor;
    int destination_floor;
    lift_request req_type;
    int boarded_lift_id = -1;
    byte person_id;

    `uvm_object_utils_begin(person_session)
        `uvm_field_int(origin_floor, UVM_ALL_ON)
        `uvm_field_int(destination_floor, UVM_ALL_ON)
        `uvm_field_enum(lift_request, req_type, UVM_ALL_ON)
        `uvm_field_int(boarded_lift_id, UVM_ALL_ON)
        `uvm_field_int(person_id, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "person_session");
        super.new(name);
    endfunction

    // "Connection shift": Once boarded, the person is associated with a specific lift
    function void board_lift(int lift_id);
        this.boarded_lift_id = lift_id;
        `uvm_info("PERSON_SESSION", $sformatf("Person %0d: Connection shifted to Lift %0d", person_id, lift_id), UVM_LOW)
    endfunction
endclass

class multi_lift_traffic_sequence #(parameter N_LIFTS = 10) extends multi_lift_base_seq#(N_LIFTS);

    `uvm_object_utils(multi_lift_traffic_sequence)

    multi_lift_controller_cfg #(`NUM_FLOORS, N_LIFTS) lift_config;

    function new(string name = "multi_lift_traffic_sequence");
        super.new(name);
    endfunction

    virtual task body();
        string s_traffic;
        op_cond req_traffic = SCARCE;

        super.body();

        if ($value$plusargs("TRAFFIC=%s", s_traffic)) begin
            if (s_traffic == "MODERATE") req_traffic = MODERATE;
            else if (s_traffic == "HEAVY") req_traffic = HEAVY;
            else if (s_traffic == "LIGHT") req_traffic = LIGHT;
            else if (s_traffic == "SCARCE") req_traffic = SCARCE;
            else if (s_traffic == "CONVERGING") req_traffic = CONVERGING;
            else if (s_traffic == "DIVERGING") req_traffic = DIVERGING;
            else if (s_traffic == "PAIRED") req_traffic = PAIRED;
            else if (s_traffic == "TWO_WAY_CONV") req_traffic = TWO_WAY_CONV;
            else if (s_traffic == "TWO_WAY_DIV") req_traffic = TWO_WAY_DIV;
            else if (s_traffic == "PAIRED_W_HOTSPOT") req_traffic = PAIRED_W_HOTSPOT;
        end

        for(int i=0;i<`MAX_REQUESTS;i++) begin
            `uvm_info(get_full_name(),$sformatf("UVM_SEQUENCE : Spawning new person session"),UVM_LOW);

            // Randomize person's initial request
            `uvm_do_with(lift_config,{lift_config.traffic == req_traffic; lift_config.req_type != STOP;})

            begin
                // Create a new person session (OOP approach)
                person_session session = person_session::type_id::create($sformatf("session_%0d", lift_config.person_id));
                session.person_id = lift_config.person_id;
                session.origin_floor = lift_config.floor;
                session.req_type = lift_config.req_type;

                fork
                    execute_person_session(req_traffic, session);
                join_none
            end

            #(lift_config.delay); // Delay between multiple people sending requests
        end
    endtask

    // Orchestrates the person's journey using the session object
    task execute_person_session(op_cond req_traffic, person_session session);
        int lift_id;
        multi_lift_controller_cfg #(`NUM_FLOORS, N_LIFTS) stop_cfg;

        // 1. Person waits for ANY elevator to arrive at the floor in the desired direction
        wait_for_any_elevator(session.origin_floor, session.req_type, session.person_id, lift_id);

        // 2. OOP Connection Shift: Person "boards" the lift that arrived first
        session.board_lift(lift_id);

        // 3. Person selects destination floor specifically in the boarded lift
        `uvm_do_with(stop_cfg,{  stop_cfg.traffic == req_traffic;
                                 stop_cfg.req_type == STOP;
                                 stop_cfg.person_id == session.person_id;
                                 stop_cfg.lift_id == session.boarded_lift_id; // Using the bound lift
                                 if (session.req_type == DN) floor < session.origin_floor;
                                 else floor > session.origin_floor;
                              })

        session.destination_floor = stop_cfg.floor;

        // 4. Person waits inside the specific elevator to reach the destination
        wait_for_specific_elevator(session.boarded_lift_id, session.destination_floor, session.person_id);
    endtask

endclass

`endif
