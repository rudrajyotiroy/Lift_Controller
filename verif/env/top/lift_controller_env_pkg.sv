`ifndef LIFT_CONTROLLER_ENV_PKG
`define LIFT_CONTROLLER_ENV_PKG

package lift_controller_env_pkg;
   
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import lift_controller_agent_pkg::*;
    // import lift_controller_ref_model_pkg::*;

    // `include "lift_controller_coverage.sv"
    `include "lift_controller_scoreboard.sv"
    `include "lift_controller_env.sv"

endpackage

`endif