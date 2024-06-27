`ifndef UVM_LIFT_CONTROLLER_TB_TOP
`define UVM_LIFT_CONTROLLER_TB_TOP

`timescale 1ns/1ps
`include "uvm_macros.svh"

// Include RTL files
// `include "lift_controller_wrapper.sv"
`include "lift_controller_assertions.sv"
`include "lift_movement_emulator.sv"

// Define to use stable single-lift version in TB

import uvm_pkg::*;
module lift_controller_tb_top;
    import lift_controller_test_pkg::*;

    // Declaration of Local Fields
    
    logic clk;
    logic reset;
    parameter N_FLOORS = 12;
    `ifndef MONO_LIFT
    parameter N_LIFTS = 10;
    `endif

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
    
    //creating instance of interface, inorder to connect DUT and testcase
    
    `ifdef MONO_LIFT
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

    `else

    /********************* DUT and Emulator (Wrapped) Instantation **********************************/
    multi_lift_controller_if #(N_FLOORS, N_LIFTS) top_if (clk, reset);
    multi_lift_controller_wrapper #(N_FLOORS, N_LIFTS) u_lift (top_if);

    `endif

    /********************* Assertion Binding by Type **********************************/
    bind lift_controller_wrapper lift_controller_assertion #(N_FLOORS) u_lift_ctrl_assertion(.lift_intf(top_if));


    /**********Set the Interface instance Using Configuration Database and run test***********/

    initial begin
        `ifdef MONO_LIFT
            uvm_config_db#(virtual lift_controller_if)::set(uvm_root::get(),"*","lift_controller_vif",top_if);
        `else
            uvm_config_db#(virtual multi_lift_controller_if)::set(uvm_root::get(),"*","lift_controller_vif",top_if);
        `endif
        run_test("lift_controller_base_test");
    end

endmodule

`endif