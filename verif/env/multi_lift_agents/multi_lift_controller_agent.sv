`ifndef MULTI_LIFT_CONTROLLER_AGENT
`define MULTI_LIFT_CONTROLLER_AGENT

class multi_lift_controller_agent #(parameter N_FLOORS = `NUM_FLOORS, parameter N_LIFTS = 10) extends uvm_agent;
    multi_lift_controller_driver #(N_FLOORS, N_LIFTS) driver;
    multi_lift_controller_monitor #(N_FLOORS, N_LIFTS) monitor;
    uvm_sequencer #(person_journey_item) sequencer;

    `uvm_component_utils(multi_lift_controller_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = multi_lift_controller_driver#(N_FLOORS, N_LIFTS)::type_id::create("driver", this);
        monitor = multi_lift_controller_monitor#(N_FLOORS, N_LIFTS)::type_id::create("monitor", this);
        sequencer = uvm_sequencer#(person_journey_item)::type_id::create("sequencer", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

`endif
