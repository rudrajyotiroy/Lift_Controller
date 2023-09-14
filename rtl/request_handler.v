`ifndef REQUEST_HANDLER
`define REQUEST_HANDLER

module register_nbit #(
    parameter N_FLOORS;
) (
    input clk,
    input reset,
    input [N_FLOORS-1] D,
    output reg [N_FLOORS-1] Q
);
    always @(posedge clk or posedge reset)
        Q = reset ? D : 0;
endmodule

// Combinational circuit with logic to update request registers
module load_data #(
    parameter N_FLOORS;
) (
    input [N_FLOORS-1:0] load,
    input [N_FLOORS-1:0] floor,
    input [N_FLOORS-1:0] reg_in,
    input flr_reset,
    output [N_FLOORS-1:0] reg_out
);
    wire [N_FLOORS-1] floor_reset_array;
    wire [N_FLOORS-1] req_array_after_reset;

    assign floor_reset_array = ~({N_FLOORS{flr_reset}} & reg_in) ;
    assign req_array_after_reset = reg_in & floor_reset_array ;
    assign reg_out = req_array_after_reset & load;
endmodule // load_data

module request_handler #(
    parameter N_FLOORS;
) (
    input clk,
    input reset,
    input [N_FLOORS-1:0] i_up_rqst,
    input [N_FLOORS-1:0] i_dn_rqst,
    input [N_FLOORS-1:0] i_flr_rqst,
    input [N_FLOORS-1:0] i_flr_pos,
    input i_up_clr,
    input i_dn_clr,
    input i_flr_clr,
    output o_up_req_queue,
    output o_dn_req_queue,
    output o_flr_req_queue
);
    wire [N_FLOORS-1:0] int_up_rqst;
    wire [N_FLOORS-1:0] int_dn_rqst;
    wire [N_FLOORS-1:0] int_flr_rqst;

    register_nbit #(N_FLOORS) up_rqst_array
    (
        .clk(clk),
        .reset(reset),
        .D(int_up_rqst),
        .Q(o_up_req_queue)
    );
    register_nbit #(N_FLOORS) dn_rqst_array
    (
        .clk(clk),
        .reset(reset),
        .D(int_dn_rqst),
        .Q(o_dn_req_queue)
    );
    register_nbit #(N_FLOORS) flr_rqst_array
    (
        .clk(clk),
        .reset(reset),
        .D(int_flr_rqst),
        .Q(o_flr_req_queue)
    );

    load_data #(N_FLOORS) up_loader_mod
    (
        .load(i_up_rqst),
        .floor(i_flr_pos),
        .reg_in(o_up_req_queue),
        .flr_reset(i_up_clr),
        .reg_out(int_up_rqst)
    );

    load_data #(N_FLOORS) dn_loader_mod
    (
        .load(i_dn_rqst),
        .floor(i_flr_pos),
        .reg_in(o_dn_req_queue),
        .flr_reset(i_dn_clr),
        .reg_out(int_dn_rqst)
    );
    
    load_data #(N_FLOORS) flr_loader_mod
    (
        .load(i_flr_rqst),
        .floor(i_flr_pos),
        .reg_in(o_flr_req_queue),
        .flr_reset(i_flr_clr),
        .reg_out(int_flr_rqst)
    );

endmodule // request_handler
`endif