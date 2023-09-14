`ifndef DOOR_CONTROLLER
`define DOOR_CONTROLLER

module door_controller #(
    parameter N_FLOORS,
    parameter DOOR_OPEN_CYCLES = 200,
    parameter EDGE_INPUTS = 2
) (
    input clk,
    input reset,
    input [EDGE_INPUTS-1:0] edge_in,
    input force_open,
    output door_open
);

reg counter_active;
reg [31:0] up_counter;

// When any 1 bit (signal) has positive edge
always @(posedge edge_in) begin
    counter_active = 1;
end
    
always @(posedge clk) begin
    if(reset) begin
        up_counter = 32'd0;
        counter_active = 0;
    end
    else if(force_open) begin
        up_counter = 32'd0;
        counter_active = 1;
    end
    else if(counter_active) begin
        up_counter = up_counter + 32'd1;
    end
end

always begin
    if(up_counter == DOOR_OPEN_CYCLES) begin
        counter_active = 0;
    end
end
assign door_open = counter_active;

endmodule

`endif