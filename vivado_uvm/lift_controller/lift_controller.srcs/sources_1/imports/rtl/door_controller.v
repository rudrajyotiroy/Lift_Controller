`ifndef DOOR_CONTROLLER
`define DOOR_CONTROLLER

module door_controller #(
    parameter N_FLOORS = 12,
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
reg [EDGE_INPUTS-1:0] counter_active_async;
reg [31:0] up_counter;

assign door_open = |(counter_active_async) | counter_active;

initial begin
    counter_active = 1'b0;
end

// When any 1 bit (signal) has positive edge
generate
    genvar i;
    for(i = 0; i < EDGE_INPUTS; i = i + 1) begin :u1
        initial begin
            counter_active_async[i] = 1'b0;
        end
        always @(posedge edge_in[i]) begin
            counter_active_async[i] = 1'b1;
        end
    end
endgenerate
    
always @(posedge clk) begin
    if(reset) begin
        up_counter = 32'd0;
        counter_active = 1'b0;
    end
    else if(force_open) begin
        up_counter = 32'd0;
        counter_active = 1'b1;
    end
    if(door_open) begin
        up_counter = up_counter + 32'd1;
    end
    if(up_counter == DOOR_OPEN_CYCLES) begin
        up_counter = 32'd0;
        counter_active = 1'b0;
        counter_active_async = {EDGE_INPUTS{1'b0}};
    end
end

endmodule

`endif