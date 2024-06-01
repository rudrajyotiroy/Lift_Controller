`ifndef LIFT_CONTROLLER_BASE_TEST
`define LIFT_CONTROLLER_BASE_TEST

class lift_controller_base_test extends uvm_test;
 
    `uvm_component_utils(lift_controller_base_test)
   
    lift_controller_environment     env;
    lift_controller_base_seq        seq;

    function new(string name = "lift_controller_base_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    
        env = lift_controller_environment::type_id::create("env", this);
        seq = lift_controller_base_seq::type_id::create("seq", this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
            seq.start(env.lift_controller_agent.sequencer);
        phase.drop_objection(this);
    endtask : run_phase
   
  endclass : lift_controller_base_test

`endif 