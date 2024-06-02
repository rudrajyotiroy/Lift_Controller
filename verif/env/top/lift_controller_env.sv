`ifndef LIFT_CONTROLLER_ENV
`define LIFT_CONTROLLER_ENV

class lift_controller_environment extends uvm_env;
 
    lift_controller_agent agent;
    lift_controller_scoreboard sb;
    // lift_controller_coverage #(lift_controller_transaction) coverage;

    `uvm_component_utils(lift_controller_environment)
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = lift_controller_agent::type_id::create("agent", this);
        // ref_model = lift_controller_ref_model::type_id::create("ref_model", this);
        // coverage = lift_controller_coverage#(lift_controller_transaction)::type_id::create("coverage", this);
        sb = lift_controller_scoreboard::type_id::create("sb", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.driver.input_txn_port.connect(sb.input_txn_export);
        agent.monitor.output_txn_port.connect(sb.output_txn_export);        
    endfunction : connect_phase

endclass : lift_controller_environment

`endif




