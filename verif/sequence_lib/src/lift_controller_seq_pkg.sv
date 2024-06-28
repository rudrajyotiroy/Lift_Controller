`ifndef LIFT_CONTROLLER_SEQ_LIST 
`define LIFT_CONTROLLER_SEQ_LIST

package lift_controller_seq_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import lift_controller_agent_pkg::*;
    import lift_controller_env_pkg::*;

    `include "lift_controller_base_seq.sv"
    `include "lift_traffic_sequence.sv"

endpackage

`endif