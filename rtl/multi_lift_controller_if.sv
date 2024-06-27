`ifndef MULTI_LIFT_CONTROLLER_INTERFACE
`define MULTI_LIFT_CONTROLLER_INTERFACE

interface multi_lift_controller_if #(parameter N_FLOORS=12, parameter N_LIFTS = 10)(input logic clk, input logic reset);
    //Request buttons on floors to go up or down
    logic [N_FLOORS-1:0] up_rqst;
    logic [N_FLOORS-1:0] dn_rqst;

    //Request buttons on lift to pick desired floor
    logic [N_FLOORS-1:0] flr_rqst [N_LIFTS-1:0];
    logic [N_LIFTS-1:0] force_open;

    //One-hot current position of lift (current floor if standing, 0 if in between two floors)
    logic [N_FLOORS-1:0] floor_sense [N_LIFTS-1:0];

    //Current direction, door open state and motion
    logic [N_LIFTS-1:0] direction;
    logic [N_LIFTS-1:0] motion;
    logic [N_LIFTS-1:0] door_open;

    //Exposed Status Lamps
    `ifdef DEBUG_INTERFACE
    logic [N_FLOORS-1:0] up_rqst_status;
    logic [N_FLOORS-1:0] dn_rqst_status;
    logic [N_FLOORS-1:0] flr_rqst_status [N_LIFTS-1:0];
    `endif
endinterface //lift_controller_if

`endif