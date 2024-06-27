`ifndef LIFT_CONTROLLER_WRAPPER
`define LIFT_CONTROLLER_WRAPPER
`include "lift_controller_if.sv"
`include "request_handler.v"
`include "door_controller.v"
`include "main_alu_block.v"

module lift_controller_wrapper #(parameter N_FLOORS=12) (
    lift_controller_if top_if
);
    wire [N_FLOORS-1:0] int_up_req_queue;
    wire [N_FLOORS-1:0] int_dn_req_queue;
    wire [N_FLOORS-1:0] int_flr_req_queue;
    wire int_up_req_clr;
    wire int_dn_req_clr;
    wire int_flr_req_clr;
    wire has_rqst_at_stopped_flr;
    wire not_moving;

    assign not_moving = ~top_if.motion;

    //Exposed Status Lamps
    `ifdef DEBUG_INTERFACE
    assign top_if.up_rqst_status = int_up_req_queue;
    assign top_if.dn_rqst_status = int_dn_req_queue;
    assign top_if.flr_rqst_status = int_flr_req_queue;
    `endif

    main_alu_block #(N_FLOORS) u_alu
    (
        .clk(top_if.clk),
        .reset(top_if.reset),
        .i_up_req_queue(int_up_req_queue),
        .i_dn_req_queue(int_dn_req_queue),
        .i_flr_req_queue(int_flr_req_queue),
        .i_flr_pos(top_if.floor_sense),
        .i_door_open(top_if.door_open),
        .o_direction(top_if.direction),
        .o_motion(top_if.motion),
        .o_up_clr(int_up_req_clr),
        .o_dn_clr(int_dn_req_clr),
        .o_flr_clr(int_flr_req_clr),
        .o_has_rqst_at_stopped_flr(has_rqst_at_stopped_flr)
    );

    request_handler #(N_FLOORS) u_req_handler
    (
        .clk(top_if.clk),
        .reset(top_if.reset),
        .i_up_rqst(top_if.up_rqst),
        .i_dn_rqst(top_if.dn_rqst),
        .i_flr_rqst(top_if.flr_rqst),
        .i_flr_pos(top_if.floor_sense),
        .i_up_clr(int_up_req_clr),
        .i_dn_clr(int_dn_req_clr),
        .i_flr_clr(int_flr_req_clr),
        .o_up_req_queue(int_up_req_queue),
        .o_dn_req_queue(int_dn_req_queue),
        .o_flr_req_queue(int_flr_req_queue)
    );

    door_controller #(N_FLOORS) u_door_ctrl
    (
        .clk(top_if.clk),
        .reset(top_if.reset),
        .edge_in({has_rqst_at_stopped_flr & not_moving}),
        .force_open(top_if.force_open),
        .door_open(top_if.door_open)
    );

    initial begin
        $display("Inside top module instantiation");
    end

endmodule

`endif