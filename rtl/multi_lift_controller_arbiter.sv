`ifndef MULTI_LIFT_CONTROLLER_ARBITER
`define MULTI_LIFT_CONTROLLER_ARBITER

module multi_lift_controller_arbiter #(parameter N_FLOORS=12, parameter N_LIFTS = 10) {
    multi_lift_controller_if #(N_FLOORS, N_LIFTS) top_if,
    lift_controller_if #(N_FLOORS) int_if [N_LIFTS-1:0]
}

genvar i;
generate
    for(i = 0; i < N_LIFTS; i = i + 1) begin
        assign int_if[i].flr_rqst = top_if.flr_rqst[i]; // All floor requests directly fwd
    end
endgenerate

// To HLS this module?

endmodule

`endif 