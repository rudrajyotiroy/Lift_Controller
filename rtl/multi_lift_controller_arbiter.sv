`ifndef MULTI_LIFT_CONTROLLER_ARBITER
`define MULTI_LIFT_CONTROLLER_ARBITER

module multi_lift_controller_arbiter #(parameter N_FLOORS=12, parameter N_LIFTS = 10) (
    multi_lift_controller_if top_if,
    lift_controller_if int_if [N_LIFTS-1:0]
);

wire [N_FLOORS-1:0] up_rqst_router [N_LIFTS-1:0]; // Arbitration crossbar (UP)
wire [N_FLOORS-1:0] dn_rqst_router [N_LIFTS-1:0]; // Arbitration crossbar (DN)

genvar i;
generate
    for(i = 0; i < N_LIFTS; i = i + 1) begin
        assign int_if[i].up_rqst = top_if.up_rqst & up_rqst_router[i];
        assign int_if[i].dn_rqst = top_if.dn_rqst & dn_rqst_router[i];
    end
endgenerate



endmodule

`endif 