`ifndef LIFT_CONTROLLER_INTERFACE
`define LIFT_CONTROLLER_INTERFACE

`define MONO_LIFT
`define DEBUG_INTERFACE

interface lift_controller_if # (parameter N_FLOORS=12)(input logic clk, input logic reset);
    //Request buttons on floors to go up or down
    logic [N_FLOORS-1:0] up_rqst;
    logic [N_FLOORS-1:0] dn_rqst;

    //Request buttons on lift to pick desired floor
    logic [N_FLOORS-1:0] flr_rqst;
    logic force_open;

    //One-hot current position of lift (current floor if standing, 0 if in between two floors)
    logic [N_FLOORS-1:0] floor_sense;

    //Current direction, door open state and motion
    logic direction;
    logic motion;
    logic door_open;

    //Exposed Status Lamps
    `ifdef DEBUG_INTERFACE
    logic [N_FLOORS-1:0] up_rqst_status;
    logic [N_FLOORS-1:0] dn_rqst_status;
    logic [N_FLOORS-1:0] flr_rqst_status;
    `endif
endinterface //lift_controller_if

`endif