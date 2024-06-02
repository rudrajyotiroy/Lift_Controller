`ifndef LIFT_CONTROLLER_AGENT 
`define LIFT_CONTROLLER_AGENT 

class lift_controller_agent extends uvm_agent;

    // Declaration of UVC components such as.. driver,monitor,sequencer..etc

    lift_controller_driver    driver;
    lift_controller_sequencer sequencer;
    lift_controller_monitor   monitor;

    `uvm_component_utils(lift_controller_agent)

    // Constructor
    function new (string name = "lift_controller_agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = lift_controller_driver::type_id::create("driver", this);
        sequencer = lift_controller_sequencer::type_id::create("sequencer", this);
        monitor = lift_controller_monitor::type_id::create("monitor", this);
    endfunction : build_phase

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase
 
endclass : lift_controller_agent

`endif
