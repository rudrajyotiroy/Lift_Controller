`ifndef MAIN_ALU_BLOCK
`define MAIN_ALU_BLOCK

module main_alu_block #(
    parameter N_FLOORS;
) (
    input clk,
    input reset,
    input [N_FLOORS-1:0] i_up_req_queue,
    input [N_FLOORS-1:0] i_dn_req_queue,
    input [N_FLOORS-1:0] i_flr_req_queue,
    input [N_FLOORS-1:0] i_flr_pos,

    output o_direction,
    output o_motion,
    output o_up_clr,
    output o_dn_clr,
    output o_flr_clr,
    output o_has_rqst_at_stopped_flr
);
    wire [N_FLOORS-1:0] up_req_or_floor_req;
    wire [N_FLOORS-1:0] dn_req_or_floor_req;
    wire [N_FLOORS-1:0] any_req;
    wire [N_FLOORS-1:0] curr_dir_req;
    wire [N_FLOORS-1:0] dn_all_flr_select;
    wire [N_FLOORS-1:0] up_all_flr_select;
    wire [N_FLOORS-1:0] curr_dir_all_flr_select;
    wire [N_FLOORS-1:0] curr_dir_oth_flr_rqst_select;
    wire w_any_rqst_at_curr_flr;
    wire x_curr_dir_has_rqst_at_oth_flr;
    wire y_at_any_flr;
    wire z_curr_dir_no_rqst_at_curr_flr;
    wire change_dir;
    reg direction;

    assign up_req_or_floor_req = i_up_req_queue | i_flr_req_queue;
    assign dn_req_or_floor_req = i_dn_req_queue | i_flr_req_queue;
    assign any_req = up_req_or_floor_req | dn_req_or_floor_req;
    assign curr_dir_req = direction ? dn_req_or_floor_req | up_req_or_floor_req;
    assign dn_all_flr_select = i_flr_pos - 1'b1;
    assign up_all_flr_select = ~(i_flr_pos & dn_all_flr_select);
    assign curr_dir_all_flr_select = direction ? dn_all_flr_select : up_all_flr_select;
    assign curr_dir_oth_flr_rqst_select = curr_dir_all_flr_select & curr_dir_req;
    assign w_any_rqst_at_curr_flr = |(any_req & i_flr_pos); // Bitwise OR (check if any request exist for current floor)
    assign x_curr_dir_has_rqst_at_oth_flr = |(curr_dir_oth_flr_rqst_select); // check if any request exist for other floors in same direction
    assign y_at_any_flr = |(i_flr_pos);
    assign z_curr_dir_no_rqst_at_curr_flr = ~|(i_flr_pos & curr_dir_req);
    
    assign o_motion = (x_curr_dir_has_rqst_at_oth_flr & z_curr_dir_no_rqst_at_curr_flr) | ~y_at_any_flr;
    assign o_direction = direction;

    assign change_dir = y_at_any_flr & ~x_curr_dir_has_rqst_at_oth_flr & z_curr_dir_no_rqst_at_curr_flr;
    assign o_has_rqst_at_stopped_flr = ~o_motion & w_any_rqst_at_curr_flr;

    initial begin
        direction = 0;
    end

    always @(posedge clk) begin
        if(reset) begin
            direction = 0;
        end
        else begin
            direction = change_dir ? direction : ~direction;
        end
    end


endmodule

`endif MAIN_ALU_BLOCK