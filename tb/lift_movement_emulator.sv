`ifndef LIFT_MOVEMENT_EMULATOR
`define LIFT_MOVEMENT_EMULATOR
// Specify time period in clks per floor
// Direction is 1 up 0 dn
// True floor state is <gnd>.....<top>
module lift_movement_emulator #(
    parameter N_FLOORS,
    parameter T = 200,
    parameter T_FLR_CONTCT = 50
) (
    input clk,
    input direction,
    input motion,
    output logic [N_FLOORS-1:0] floor_sense
);

// Goal : Realistic model, consider all scenarios
reg [N_FLOORS-1:0] true_floor_state;
integer count;

initial begin
    true_floor_state = 12'd1;
    floor_sense = true_floor_state;
    count = 0;
end

always @(posedge clk) begin
    if(motion) begin
        count = direction ? count + 1 : count - 1;
        if(count == T) begin
            true_floor_state = true_floor_state << 1;
            floor_sense = true_floor_state;
            count = 0;
        end
        if(count == -T) begin
            true_floor_state = true_floor_state >> 1;
            floor_sense = true_floor_state;
            count = 0;
        end
        if(count > T_FLR_CONTCT) begin
            floor_sense = {N_FLOORS{1'b0}};
        end
        if(count < -T_FLR_CONTCT) begin
            floor_sense = {N_FLOORS{1'b0}};
        end
    end
end

// Space for movement constraint assertions

// Assertion 0 : Lift direction should not change when lift is in motion
// Assertion 1 : Lift should not stop in between floors except for reset
// Assertion 2 : Lift should never continue movement beyond ground floor or top floor
// Assertion 3 : Door can only open when lift is stationary
// Assertion 4 : True floor state should be one hot always (indicating last floor left) 
// Assertion 5 : Once door open, should stay open for DOOR_OPEN_REQ clock cycles

endmodule

`endif