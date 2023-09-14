`ifndef LIFT_CONTROLLER_INTERFACE
`define LIFT_CONTROLLER_INTERFACE

interface lift_controller_if # (parameter N_FLOORS)(input logic clk, input logic reset);
    //Request buttons on floors to go up or down
    input logic [N_FLOORS-1:0] up_rqst;
    input logic [N_FLOORS-1:0] dn_rqst;

    //Request buttons on lift to pick desired floor
    input logic [N_FLOORS-1:0] flr_rqst;
    input logic force_open;

    //One-hot current position of lift (current floor if standing, 0 if in between two floors)
    input logic [N_FLOORS-1:0] floor_sense;

    //Current direction, door open state and motion
    output logic direction;
    output logic motion;
    output logic door_open;
endinterface //lift_controller_if

`endif