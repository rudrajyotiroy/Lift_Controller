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

    // Assertion 3: Whenever lift moves, direction should remain stable, non-overlapped implication is used
    property dir_motion_check();
        @(posedge lift_intf.clk)
        (lift_intf.motion == 1'b1) |=> $stable(lift_intf.direction);
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

    // Assertion 5: If door is opened, it should stay open for atleast 150 clock edges

    property door_open_stable_check();
        @(posedge lift_intf.clk) 
        $rose(lift_intf.door_open) |-> ##1 $stable(lift_intf.door_open)[*150];
    endproperty
    assert property (door_open_stable_check)
    else `uvm_error("DOOR_OPEN_STABLE_CHECK", "Door was opened and closed before 150 cycles elapsed");

    // Assertion 6: Floor sense and request arrays are onehot0

    property floor_sense_one_hot_or_zero_check();
        @(posedge lift_intf.clk) $onehot0(lift_intf.floor_sense);
    endproperty
    assert property (floor_sense_one_hot_or_zero_check)
    else `uvm_error("FLOOR_SENSE_ONE_HOT_CHECK", "floor_sense is NOT one-hot or zero");

    property up_rqst_one_hot_or_zero_check();
        @(posedge lift_intf.clk) $onehot0(lift_intf.up_rqst);
    endproperty
    assert property (up_rqst_one_hot_or_zero_check)
    else `uvm_error("UP_RQST_ONE_HOT_CHECK", "up_rqst is NOT one-hot or zero");

    property dn_rqst_one_hot_or_zero_check();
        @(posedge lift_intf.clk) $onehot0(lift_intf.dn_rqst);
    endproperty
    assert property (dn_rqst_one_hot_or_zero_check)
    else `uvm_error("DN_RQST_ONE_HOT_CHECK", "dn_rqst is NOT one-hot or zero");

    property flr_rqst_one_hot_or_zero_check();
        @(posedge lift_intf.clk) $onehot0(lift_intf.flr_rqst);
    endproperty
    assert property (flr_rqst_one_hot_or_zero_check)
    else `uvm_error("FLR_RQST_ONE_HOT_CHECK", "flr_rqst is NOT one-hot or zero");

    // Assertion 7: Request clearing checks, when request is cleared lift should be stopped at appropriate floor in appropriate dir and door should be open just before that
    
    property up_request_clear_check();
        @(posedge lift_intf.clk)
        ((lift_intf.up_rqst_status ^ $past(lift_intf.up_rqst_status)) & ~lift_intf.up_rqst_status) |-> 
        (($past(lift_intf.motion) == 1'b0) && 
        ($past(lift_intf.door_open, 2) == 1'b1) && 
        ($past(lift_intf.direction) == 1'b1) &&
        ((lift_intf.up_rqst_status ^ $past(lift_intf.up_rqst_status)) & lift_intf.floor_sense) != 0);
    endproperty
    assert property (up_request_clear_check)
    else `uvm_error("UP_REQUEST_CLEAR_CHECK", "Up request clear check failed: Lift up request should be cleared only when the lift is stopped at the appropriate floor, the door is open, and the direction is up.");

    property dn_request_clear_check();
        @(posedge lift_intf.clk)
        ((lift_intf.dn_rqst_status ^ $past(lift_intf.dn_rqst_status)) & ~lift_intf.dn_rqst_status) |-> 
        (($past(lift_intf.motion) == 1'b0) && 
        ($past(lift_intf.door_open, 2) == 1'b1) && 
        ($past(lift_intf.direction) == 1'b0) &&
        ((lift_intf.dn_rqst_status ^ $past(lift_intf.dn_rqst_status)) & lift_intf.floor_sense) != 0);
    endproperty
    assert property (dn_request_clear_check)
    else `uvm_error("DN_REQUEST_CLEAR_CHECK", "Down request clear check failed: Lift down request should be cleared only when the lift is stopped at the appropriate floor, the door is open, and the direction is down.");

    property flr_request_clear_check();
        @(posedge lift_intf.clk)
        ((lift_intf.flr_rqst_status ^ $past(lift_intf.flr_rqst_status)) & ~lift_intf.flr_rqst_status) |-> 
        (($past(lift_intf.motion) == 1'b0) && 
        ($past(lift_intf.door_open, 2) == 1'b1) && 
        ((lift_intf.flr_rqst_status ^ $past(lift_intf.flr_rqst_status)) & lift_intf.floor_sense) != 0);
    endproperty
    assert property (flr_request_clear_check)
    else `uvm_error("FLR_REQUEST_CLEAR_CHECK", "Floor request clear check failed: Lift floor request should be cleared only when the lift is stopped at the appropriate floor and the door is open.");
    

endmodule

`endif