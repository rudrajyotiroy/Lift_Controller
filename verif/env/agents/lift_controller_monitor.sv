`ifndef LIFT_CONTROLLER_MONITOR
`define LIFT_CONTROLLER_MONITOR

class lift_controller_monitor extends uvm_monitor;

    // Virtual interface
    virtual lift_controller_if lift_controller_vif;
  
    // Analysis port to send the transaction to the scoreboard or other components
    uvm_analysis_port #(lift_controller_seq_item) output_txn_port;
  
    // Constructor
    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

endclass : lift_controller_monitor

`endif