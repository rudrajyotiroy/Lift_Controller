`ifndef MULTI_LIFT_CONTROLLER_AGENT_PKG
`define MULTI_LIFT_CONTROLLER_AGENT_PKG

package multi_lift_controller_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import lift_controller_agent_pkg::*;

    `include "multi_lift_controller_cfg.sv"
    `include "multi_lift_controller_driver.sv"
    `include "multi_lift_controller_monitor.sv"
    `include "multi_lift_controller_agent.sv"
endpackage

`endif
