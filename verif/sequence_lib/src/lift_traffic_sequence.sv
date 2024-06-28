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
        byte person_id;

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
            
            `uvm_do_with(lift_config,{lift_config.traffic == req_traffic; lift_config.req_type != STOP;})
            person_id = lift_config.person_id;
            fork
                begin
                    super.wait_for_elevator(lift_config.floor, lift_config.req_type, person_id);
                    // #10; // Dummy
                    `uvm_do_with(lift_config,{lift_config.traffic == req_traffic; lift_config.req_type == STOP; lift_config.person_id == person_id;})
                    // #10; // Dummy
                    super.wait_for_elevator(lift_config.floor, lift_config.req_type, person_id);
                end
            join_none
            #(lift_config.delay); // Delay
        end
    endtask

endclass

`endif