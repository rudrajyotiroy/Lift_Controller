`ifndef LIFT_CONTROLLER_AGENT_PKG
`define LIFT_CONTROLLER_AGENT_PKG

package lift_controller_agent_pkg;
 
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "lift_controller_defines.svh"
    `include "lift_controller_cfg.sv"
    `include "lift_controller_seq_item.sv"
    `include "lift_controller_sequencer.sv"
    `include "lift_controller_driver.sv"
    `include "lift_controller_monitor.sv"
    `include "lift_controller_agent.sv"

endpackage

`endif