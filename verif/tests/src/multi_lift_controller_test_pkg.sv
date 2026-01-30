`ifndef MULTI_LIFT_CONTROLLER_TEST_PKG
`define MULTI_LIFT_CONTROLLER_TEST_PKG

package multi_lift_controller_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import lift_controller_agent_pkg::*;
    import lift_controller_env_pkg::*;
    import lift_controller_seq_pkg::*;
    import multi_lift_controller_agent_pkg::*;
    import multi_lift_controller_env_pkg::*;

    `include "multi_lift_base_seq.sv"
    `include "multi_lift_traffic_sequence.sv"
    `include "multi_lift_base_test.sv"

endpackage

`endif
