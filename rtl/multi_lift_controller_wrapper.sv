`ifndef MULTI_LIFT_CONTROLLER_WRAPPER
`define MULTI_LIFT_CONTROLLER_WRAPPER

`include "multi_lift_controller_if.sv"
`include "lift_controller_wrapper.sv"
`include "lift_movement_emulator.sv"
`include "lift_controller_arbiter.sv"

module multi_lift_controller_wrapper #(parameter N_FLOORS=12, parameter N_LIFTS = 10) (
    multi_lift_controller_if #(N_FLOORS, N_LIFTS) top_if
);

// Intermediate Interfaces
lift_controller_if #(N_FLOORS) int_if [N_LIFTS-1:0] (top_if.clk, top_if.reset);

// Each Elevator and Corresponding control logic
genvar i;
generate
    for(i = 0; i < N_LIFTS; i = i + 1) begin
        lift_controller_wrapper #(N_FLOORS) u_lift_ctrl (int_if[i]);
        lift_movement_emulator #(N_FLOORS) u_lift_emul 
        (
            .clk(int_if[i].clk),
            .direction(int_if[i].direction),
            .motion(int_if[i].motion),
            .floor_sense(int_if[i].floor_sense)
        );
    end
endgenerate

// Lift control arbiter
multi_lift_controller_arbiter #(N_FLOORS, N_LIFTS) u_arbiter (top_if, int_if);

endmodule

`endif