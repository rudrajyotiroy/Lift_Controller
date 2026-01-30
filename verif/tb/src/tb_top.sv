`ifndef UVM_LIFT_CONTROLLER_TB_TOP
`define UVM_LIFT_CONTROLLER_TB_TOP

`timescale 1ns/1ps
`include "uvm_macros.svh"

`ifdef COMPILE_VCS
    // Include Defines, RTL files
    `include "lift_controller_defines.svh"
    `include "lift_controller_wrapper.sv"

    `ifndef MONO_LIFT
        `include "multi_lift_controller_wrapper.sv"
    `endif
`endif

// Include Assertion and Movement Emulator
`include "lift_controller_assertions.sv"
`include "lift_movement_emulator.sv"

import uvm_pkg::*;
import lift_controller_agent_pkg::*;
import lift_controller_env_pkg::*;
import lift_controller_seq_pkg::*;
import lift_controller_test_pkg::*;

`ifndef MONO_LIFT
import multi_lift_controller_agent_pkg::*;
import multi_lift_controller_env_pkg::*;
import multi_lift_controller_test_pkg::*;
`endif

module lift_controller_tb_top;

    // Declaration of Local Fields
    
    logic clk;
    logic reset;
    parameter N_FLOORS = `NUM_FLOORS;
    parameter N_LIFTS = `NUM_LIFTS;

    //clock generation
    
    initial begin
        clk = 1'b0;
        forever begin
            #1 clk = ~clk;
        end
    end
    
    //reset Generation
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

    // Individual interfaces for monitoring
    lift_controller_if #(N_FLOORS) lift_vif [N_LIFTS] (clk, reset);

    genvar i;
    generate
        for (i = 0; i < N_LIFTS; i = i + 1) begin
            assign lift_vif[i].floor_sense = u_lift.int_if[i].floor_sense;
            assign lift_vif[i].direction = u_lift.int_if[i].direction;
            assign lift_vif[i].motion = u_lift.int_if[i].motion;
            assign lift_vif[i].door_open = u_lift.int_if[i].door_open;
            assign lift_vif[i].up_rqst = u_lift.int_if[i].up_rqst;
            assign lift_vif[i].dn_rqst = u_lift.int_if[i].dn_rqst;
            assign lift_vif[i].flr_rqst = u_lift.int_if[i].flr_rqst;
            assign lift_vif[i].force_open = u_lift.int_if[i].force_open;

            `ifdef DEBUG_INTERFACE
            assign lift_vif[i].up_rqst_status = u_lift.int_if[i].up_rqst_status;
            assign lift_vif[i].dn_rqst_status = u_lift.int_if[i].dn_rqst_status;
            assign lift_vif[i].flr_rqst_status = u_lift.int_if[i].flr_rqst_status;
            `endif
        end
    endgenerate

    `endif

    /********************* Assertion Binding by Type **********************************/
    bind lift_controller_wrapper lift_controller_assertion #(N_FLOORS) u_lift_ctrl_assertion(.lift_intf(top_if));


    /**********Set the Interface instance Using Configuration Database and run test***********/

    initial begin
        `ifdef MONO_LIFT
            uvm_config_db#(virtual lift_controller_if #(N_FLOORS))::set(uvm_root::get(),"*","lift_controller_vif",top_if);
        `else
            uvm_config_db#(virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS))::set(uvm_root::get(),"*","multi_lift_controller_vif",top_if);
            for (int j = 0; j < N_LIFTS; j++) begin
                uvm_config_db#(virtual lift_controller_if #(N_FLOORS))::set(uvm_root::get(), $sformatf("*.single_agent_%0d*", j), "lift_controller_vif", lift_vif[j]);
                uvm_config_db#(virtual lift_controller_if #(N_FLOORS))::set(uvm_root::get(), "*", $sformatf("lift_vif_%0d", j), lift_vif[j]);
            end
        `endif
        run_test();
    end

endmodule

`endif
