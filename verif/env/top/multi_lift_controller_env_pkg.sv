`ifndef MULTI_LIFT_CONTROLLER_ENV_PKG
`define MULTI_LIFT_CONTROLLER_ENV_PKG

package multi_lift_controller_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import lift_controller_agent_pkg::*;
    import lift_controller_env_pkg::*;
    import multi_lift_controller_agent_pkg::*;

    `include "multi_lift_controller_env.sv"
endpackage

`endif
