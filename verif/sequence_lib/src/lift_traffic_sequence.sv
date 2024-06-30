`ifndef LIFT_TRAFFIC_SEQUENCE 
`define LIFT_TRAFFIC_SEQUENCE

class lift_traffic_sequence extends lift_controller_base_seq;

    `uvm_object_utils(lift_traffic_sequence)

    lift_controller_cfg lift_config;

    function new(string name = "lift_traffic_sequence");
        super.new(name);
    endfunction

    virtual task body();
        string s_traffic;
        op_cond req_traffic = MODERATE;

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
            `uvm_info(get_full_name(),$sformatf("UVM_SEQUENCE : Send request traffic and add delay"),UVM_LOW);
            
            // Person requests elevator from certain floor
            `uvm_do_with(lift_config,{lift_config.traffic == req_traffic; lift_config.req_type != STOP;})
            fork
                single_person_behav(req_traffic, lift_config.person_id, lift_config.floor, lift_config.req_type);
                // We do not want one person's waiting actions to prohibit any other person
            join_none
            #(lift_config.delay); // Delay between multiple people sending requests
        end
    endtask

    task single_person_behav(op_cond req_traffic, byte unsigned person_id, int curr_floor, lift_request req_type);
        lift_controller_cfg curr_lift_config;

        // Person waits for elevator to arrive at that floor and door open
        super.wait_for_elevator(curr_floor, req_type, person_id);
        // Person gets in and selects appropriate destination floor in desired direction only
        if(req_type == DN) begin
            `uvm_do_with(curr_lift_config,{  curr_lift_config.traffic == req_traffic;
            curr_lift_config.req_type == STOP; 
            curr_lift_config.person_id == person_id;
            curr_lift_config.floor < curr_floor;}) 
        end else begin
            `uvm_do_with(curr_lift_config,{  curr_lift_config.traffic == req_traffic;
            curr_lift_config.req_type == STOP; 
            curr_lift_config.person_id == person_id;
            curr_lift_config.floor > curr_floor;}) 
        end
        // Person waits inside elevator to reach that floor, and then deboards
        super.wait_for_elevator(curr_lift_config.floor, curr_lift_config.req_type, person_id);
    endtask

endclass

`endif