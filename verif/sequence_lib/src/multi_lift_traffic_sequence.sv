`ifndef MULTI_LIFT_TRAFFIC_SEQUENCE
`define MULTI_LIFT_TRAFFIC_SEQUENCE

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
            `uvm_info(get_full_name(),$sformatf("UVM_SEQUENCE : Send multi-lift request traffic and add delay"),UVM_LOW);

            // Person requests elevator from certain floor
            `uvm_do_with(lift_config,{lift_config.traffic == req_traffic; lift_config.req_type != STOP;})
            fork
                int f = lift_config.floor;
                lift_request rt = lift_config.req_type;
                byte pid = lift_config.person_id;
                single_person_behav(req_traffic, pid, f, rt);
            join_none
            #(lift_config.delay); // Delay between multiple people sending requests
        end
    endtask

    task single_person_behav(op_cond req_traffic, byte unsigned person_id, int curr_floor, lift_request req_type);
        int lift_id;
        multi_lift_controller_cfg #(`NUM_FLOORS, N_LIFTS) stop_cfg;

        // Person waits for ANY elevator to arrive at that floor and door open
        wait_for_any_elevator(curr_floor, req_type, person_id, lift_id);

        // Person gets in and selects appropriate destination floor in THAT elevator
        if(req_type == DN) begin
            `uvm_do_with(stop_cfg,{  stop_cfg.traffic == req_traffic;
                                     stop_cfg.req_type == STOP;
                                     stop_cfg.person_id == person_id;
                                     stop_cfg.lift_id == lift_id;
                                     stop_cfg.floor < curr_floor;})
        end else begin
            `uvm_do_with(stop_cfg,{  stop_cfg.traffic == req_traffic;
                                     stop_cfg.req_type == STOP;
                                     stop_cfg.person_id == person_id;
                                     stop_cfg.lift_id == lift_id;
                                     stop_cfg.floor > curr_floor;})
        end
        // Person waits inside elevator to reach that floor, and then deboards
        wait_for_specific_elevator(lift_id, stop_cfg.floor, person_id);
    endtask

endclass

`endif
