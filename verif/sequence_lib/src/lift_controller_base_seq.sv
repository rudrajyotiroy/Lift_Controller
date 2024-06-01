`ifndef LIFT_CONTROLLER_BASE_SEQ 
`define LIFT_CONTROLLER_BASE_SEQ

class lift_controller_base_seq extends uvm_sequence#(lift_controller_cfg);
   
    `uvm_object_utils(lift_controller_base_seq)

    lift_controller_cfg lift_config;

    function new(string name = "lift_controller_base_seq");
        super.new(name);
    endfunction

    virtual task body();
        for(int i=0;i<`MAX_REQUESTS;i++) begin
            `uvm_info(get_full_name(),$sformatf("UVM_SEQUENCE : Send request traffic and add delay"),UVM_LOW);
            `uvm_do_with(lift_config,{lift_config.traffic == MODERATE;})
            #(lift_config.delay); // Delay
        end
    endtask
   
endclass

`endif


