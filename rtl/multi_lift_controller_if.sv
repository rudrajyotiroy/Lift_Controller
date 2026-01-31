`ifndef MULTI_LIFT_CONTROLLER_INTERFACE
`define MULTI_LIFT_CONTROLLER_INTERFACE

interface multi_lift_controller_if #(parameter N_FLOORS=12, parameter N_LIFTS = 10)(input logic clk, input logic reset);
    //Request buttons on floors to go up or down
    logic [N_FLOORS-1:0] up_rqst;
    logic [N_FLOORS-1:0] dn_rqst;

    //Exposed Status Lamps
    `ifdef DEBUG_INTERFACE
    logic [N_FLOORS-1:0] up_rqst_status;
    logic [N_FLOORS-1:0] dn_rqst_status;
    `endif

    // Helper to get global status (OR of all lifts)
    logic [N_FLOORS-1:0] global_up_rqst_status;
    logic [N_FLOORS-1:0] global_dn_rqst_status;

endinterface //multi_lift_controller_if

`endif
