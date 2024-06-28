`ifndef LIFT_CONTROLLER_SEQUENCER
`define LIFT_CONTROLLER_SEQUENCER

class lift_controller_sequencer extends uvm_sequencer#(lift_controller_cfg);

    `uvm_component_utils(lift_controller_sequencer)

    ///////////////////////////////////////////////////////////////////////////////
    //constructor
    ///////////////////////////////////////////////////////////////////////////////
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
   
endclass

`endif