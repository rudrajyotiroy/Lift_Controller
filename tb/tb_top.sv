`ifndef TB_TOP
`define TB_TOP

enum { UP, DOWN, STOP, NULL } lift_request;

function bit [11:0] DECIMAL_TO_ONE_HOT(input int decimal_input);
    bit [11:0] onehot_output;

    // Initialize the output to all zeros
    onehot_output = 12'b0;

    // Check if the input is within the valid range (0 to 11)
    if (decimal_input >= 0 && decimal_input <= 11) begin
        // Set the corresponding bit to '1'
        onehot_output[decimal_input] = 1'b1;
    end else begin
        // Handle invalid inputs by setting the output to all zeros
        onehot_output = 12'b0;
    end

    // Return the one-hot encoding
    return onehot_output;
endfunction

task SEND_REQUEST(int floor, lift_request req);
    if(req == UP) begin
        top_if.up_rqst = DECIMAL_TO_ONE_HOT(floor);
        repeat(5)
            @(posedge clk);
        top_if.up_rqst = 12'b0;
    end
    else if(req == DN) begin
        top_if.dn_rqst = DECIMAL_TO_ONE_HOT(floor);
        repeat(5)
            @(posedge clk);
        top_if.dn_rqst = 12'b0;
    end
    else if(req == STOP) begin
        top_if.flr_rqst = DECIMAL_TO_ONE_HOT(floor);
        repeat(5)
            @(posedge clk);
        top_if.flr_rqst = 12'b0;
    end
    else if(req == NULL) begin
        top_if.up_rqst <= 12'b0;
        top_if.dn_rqst <= 12'b0;
        top_if.flr_rqst <= 12'b0;
    end
    
endtask //SEND_REQUEST

module tb();
    logic clk;
    logic reset;
    
    lift_controller_if top_if(clk, reset);

    lift_controller_wrapper #(12) u_lift_ctrl (top_if);
    lift_movement_emulator #(12) u_lift 
    (
        .clk(clk),
        .reset(reset),
        .direction(top_if.direction),
        .motion(top_if.motion),
        .door_open(top_if.door_open),
        .floor_sense(top_if.floor_sense)
    )

    initial begin
        clk = 0;
        reset = 1;
        SEND_REQUEST(0,NULL);
        top_if.force_open = 0;
        #10 reset = 0;
        // Start of stimuli
        SEND_REQUEST(3,UP);
        #100;
        SEND_REQUEST(2,DN);
        #100;
        SEND_REQUEST(6,STOP);
        #100;
        $finish;
    end

    forever begin
        #5 clk = ~clk;
    end

    // Very basic checker
    forever begin
        @(negedge top_if.floor_sense);
        $$display("Lift has left floor : %b", top_if.floor_sense);
    end

    forever begin
        @(posedge top_if.floor_sense);
        $$display("Currently lift is at floor : %b", top_if.floor_sense);
    end

endmodule

`endif TB_TOP