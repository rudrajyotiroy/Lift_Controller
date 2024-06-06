`ifndef LIFT_CONTROLLER_ASSERTION_MODULE
`define LIFT_CONTROLLER_ASSERTION_MODULE
`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

module lift_controller_assertion #(parameter N_FLOORS=12)
(
    lift_controller_if lift_intf
);

    // Assertion 1: Whenever door is opened or closed lift should not be in motion
    property door_motion_check();
        @(posedge lift_intf.clk)
        $fell(lift_intf.door_open) || $rose(lift_intf.door_open) |-> lift_intf.motion == 1'b0;
    endproperty
    assert property (door_motion_check)
    else `uvm_error("DOOR_MOTION_CHECK", "Door open/close check failed: Lift should not be in motion when door is opening/closing.");

    // Assertion 2: Whenever lift is in motion door should be closed
    property motion_door_check();
        @(posedge lift_intf.clk)
        lift_intf.motion == 1'b1 |-> lift_intf.door_open == 1'b0;
    endproperty
    assert property (motion_door_check)
    else `uvm_error("MOTION_DOOR_CHECK", "Motion check failed: Lift should have the door closed while in motion.");

    // Assertion 3: Whenever lift direction changes, lift should be static
    property dir_motion_check();
        @(posedge lift_intf.clk)
        $fell(lift_intf.direction) || $rose(lift_intf.direction) |-> (lift_intf.motion == 1'b0) | (lift_intf.motion == 1'b0);
    endproperty
    assert property (dir_motion_check)
    else `uvm_error("DIR_MOTION_CHECK", "Direction Change Check Failed: Lift should be static when direction is changed.");

    // Assertion 4: Lift should not stop in between floors
    property motion_floor_check();
        @(posedge lift_intf.clk)
        lift_intf.floor_sense == {N_FLOORS{1'b0}} |-> lift_intf.motion == 1'b1;
    endproperty
    assert property (motion_floor_check)
    else `uvm_error("MOTION_FLOOR_CHECK", "Motion check failed: Lift should not stop when in-between floors.");

    // Assertion 4: Request clearing checks (To be binded to request array later, NOT at this hierarchy)
    /*
    property up_request_clear_check();
        @(posedge lift_intf.clk)
        ((lift_intf.up_rqst ^ $past(lift_intf.up_rqst)) & ~lift_intf.up_rqst) |-> 
        ((lift_intf.motion == 1'b0) && 
        (lift_intf.door_open == 1'b1) && 
        (lift_intf.direction == 1'b1) &&
        ((lift_intf.up_rqst ^ $past(lift_intf.up_rqst)) & lift_intf.floor_sense) != 0);
    endproperty
    assert property (up_request_clear_check)
    else `uvm_error("UP_REQUEST_CLEAR_CHECK", "Up request clear check failed: Lift up request should be cleared only when the lift is stopped at the appropriate floor, the door is open, and the direction is up.");

    property dn_request_clear_check();
        @(posedge lift_intf.clk)
        ((lift_intf.dn_rqst ^ $past(lift_intf.dn_rqst)) & ~lift_intf.dn_rqst) |-> 
        ((lift_intf.motion == 1'b0) && 
        (lift_intf.door_open == 1'b1) && 
        (lift_intf.direction == 1'b0) &&
        ((lift_intf.dn_rqst ^ $past(lift_intf.dn_rqst)) & lift_intf.floor_sense) != 0);
    endproperty
    assert property (dn_request_clear_check)
    else `uvm_error("DN_REQUEST_CLEAR_CHECK", "Down request clear check failed: Lift down request should be cleared only when the lift is stopped at the appropriate floor, the door is open, and the direction is down.");

    property flr_request_clear_check();
        @(posedge lift_intf.clk)
        ((lift_intf.flr_rqst ^ $past(lift_intf.flr_rqst)) & ~lift_intf.flr_rqst) |-> 
        ((lift_intf.motion == 1'b0) && 
        (lift_intf.door_open == 1'b1) && 
        ((lift_intf.flr_rqst ^ $past(lift_intf.flr_rqst)) & lift_intf.floor_sense) != 0);
    endproperty
    assert property (flr_request_clear_check)
    else `uvm_error("FLR_REQUEST_CLEAR_CHECK", "Floor request clear check failed: Lift floor request should be cleared only when the lift is stopped at the appropriate floor and the door is open.");
    */

endmodule

`endif