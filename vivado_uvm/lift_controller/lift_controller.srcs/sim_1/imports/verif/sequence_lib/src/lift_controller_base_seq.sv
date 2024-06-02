`ifndef LIFT_CONTROLLER_BASE_SEQ 
`define LIFT_CONTROLLER_BASE_SEQ

class lift_controller_base_seq extends uvm_sequence#(lift_controller_cfg);
   
    `uvm_object_utils(lift_controller_base_seq)

    lift_controller_cfg lift_config;
    uvm_phase phase;

    function new(string name = "lift_controller_base_seq");
        super.new(name);
    endfunction

    task pre_body();
        `uvm_info(get_type_name(), "Inside pre_body", UVM_LOW);
        phase = get_starting_phase; // Retrieve phase information
        if (phase != null) phase.raise_objection(this);
    endtask

    virtual task body();
        `uvm_info(get_full_name(),$sformatf("UVM_SEQUENCE : Entering main test"),UVM_LOW);
        for(int i=0;i<`MAX_REQUESTS;i++) begin
            `uvm_info(get_full_name(),$sformatf("UVM_SEQUENCE : Send request traffic and add delay"),UVM_LOW);
            `uvm_do_with(lift_config,{lift_config.traffic == MODERATE;})
            #(lift_config.delay); // Delay
        end
        #(`DRAIN_TIME);
        `uvm_info(get_full_name(),$sformatf("UVM_SEQUENCE : Exiting main test"),UVM_LOW);
    endtask

    task post_body();
        `uvm_info(get_type_name(), "Inside post_body", UVM_LOW);
        if (phase != null) phase.drop_objection(this);
    endtask
   
endclass

`endif


