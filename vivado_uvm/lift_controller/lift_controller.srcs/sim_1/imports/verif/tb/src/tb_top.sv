`ifndef UVM_LIFT_CONTROLLER_TB_TOP
`define UVM_LIFT_CONTROLLER_TB_TOP
`include "uvm_macros.svh"

// Include RTL files
// `include "lift_controller_wrapper.sv"
`include "lift_movement_emulator.sv"

import uvm_pkg::*;
module lift_controller_tb_top;
    import lift_controller_test_pkg::*;

    // Declaration of Local Fields
    
    logic clk;
    logic reset;
    parameter N_FLOORS = 12;

    //clock generation
    
    initial begin
        clk = 1'b0;
        forever begin
            #1 clk = ~clk;
        end
    end
    
    //reset Generation : change may required while generating reset for 
    //                   synchronous/Asynchronous or Active low/Active high
    
    initial begin
        reset = 1;  
        #5 reset = 0;
    end
    
    //creatinng instance of interface, inorder to connect DUT and testcase
    
    lift_controller_if #(N_FLOORS) top_if(clk, reset);

    /********************* DUT (and Emulator) Instantation **********************************/

    lift_controller_wrapper #(N_FLOORS) u_lift_ctrl (top_if);
    lift_movement_emulator #(N_FLOORS) u_lift 
    (
        .clk(clk),
        .direction(top_if.direction),
        .motion(top_if.motion),
        .floor_sense(top_if.floor_sense)
    );


    /**********Set the Interface instance Using Configuration Database and run test***********/

    initial begin
        uvm_config_db#(virtual lift_controller_if)::set(uvm_root::get(),"*","intf",top_if);
        run_test();
    end

endmodule

`endif