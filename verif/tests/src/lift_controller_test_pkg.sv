`ifndef LIFT_CONTROLLER_TEST_PKG
`define LIFT_CONTROLLER_TEST_PKG

package lift_controller_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import lift_controller_agent_pkg::*;
    import lift_controller_env_pkg::*;
    import lift_controller_seq_pkg::*;

    //////////////////////////////////////////////////////////////////////////////
    // including lift_controller test list
    //////////////////////////////////////////////////////////////////////////////

    `include "lift_controller_base_test.sv"

endpackage 

`endif
