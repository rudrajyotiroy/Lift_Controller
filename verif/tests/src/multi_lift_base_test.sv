`ifndef MULTI_LIFT_BASE_TEST
`define MULTI_LIFT_BASE_TEST

class multi_lift_base_test extends uvm_test;

    `uvm_component_utils(multi_lift_base_test)

    multi_lift_controller_environment #(`NUM_FLOORS, `NUM_LIFTS) env;
    multi_lift_traffic_sequence #(`NUM_LIFTS) seq;

    function new(string name = "multi_lift_base_test", uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = multi_lift_controller_environment#(`NUM_FLOORS, `NUM_LIFTS)::type_id::create("env", this);
        seq = multi_lift_traffic_sequence#(`NUM_LIFTS)::type_id::create("seq", this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
            seq.start(env.multi_agent.sequencer);
        phase.drop_objection(this);
    endtask : run_phase

  endclass : multi_lift_base_test

`endif
