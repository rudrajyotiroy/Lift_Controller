`ifndef TB_TOP
`define TB_TOP
`include "rtl/lift_controller_wrapper.v"
`include "tb/lift_movement_emulator.sv"

typedef enum { UP, DN, STOP, NULL } lift_request;

virtual class ENCODER #(parameter N_FLOORS = 12);
    static function bit [N_FLOORS-1:0] DECIMAL_TO_ONE_HOT(input int decimal_input);
        bit [N_FLOORS-1:0] onehot_output;

        // Initialize the output to all zeros
        onehot_output = {N_FLOORS{1'b0}};

        // Check if the input is within the valid range (1 to N_FLOORS)
        if (decimal_input > 0 && decimal_input <= N_FLOORS) begin
            // Set the corresponding bit to '1'
            onehot_output[decimal_input-1] = 1'b1;
        end else begin
            // Handle invalid inputs by setting the output to all ones
            onehot_output = {N_FLOORS{1'b1}};
        end

        // Return the one-hot encoding
        return onehot_output;
    endfunction

    // Static function for getting current floor ID
    /* NOT REQUIRED ATM
    static function int ONE_HOT_TO_DECIMAL(input [N_FLOORS-1:0] onehot_input);
        int dec_output;
        int ctr;

        for (ctr = 1; ctr <= N_FLOORS; ctr = ctr + 1) begin
            if(onehot_input[ctr] == 1'b1) begin
                dec_output = ctr + 1;
            end
        end

        return dec_output;
        
    endfunction
    */
endclass

module tb();
    logic clk;
    logic reset;
    parameter N_FLOORS = 12;
    
    lift_controller_if #(N_FLOORS) top_if(clk, reset);

    lift_controller_wrapper #(N_FLOORS) u_lift_ctrl (top_if);
    lift_movement_emulator #(N_FLOORS) u_lift 
    (
        .clk(clk),
        .direction(top_if.direction),
        .motion(top_if.motion),
        .floor_sense(top_if.floor_sense)
    );

    task SEND_REQUEST(int floor, lift_request req);
        if(req == UP) begin
            top_if.up_rqst = ENCODER #(N_FLOORS)::DECIMAL_TO_ONE_HOT(floor);
            repeat(5)
                @(posedge clk);
            top_if.up_rqst = {N_FLOORS{1'b0}};
        end
        else if(req == DN) begin
            top_if.dn_rqst = ENCODER #(N_FLOORS)::DECIMAL_TO_ONE_HOT(floor);
            repeat(5)
                @(posedge clk);
            top_if.dn_rqst = {N_FLOORS{1'b0}};
        end
        else if(req == STOP) begin
            top_if.flr_rqst = ENCODER #(N_FLOORS)::DECIMAL_TO_ONE_HOT(floor);
            repeat(5)
                @(posedge clk);
            top_if.flr_rqst = {N_FLOORS{1'b0}};
        end
        else if(req == NULL) begin
            top_if.up_rqst <= {N_FLOORS{1'b0}};
            top_if.dn_rqst <= {N_FLOORS{1'b0}};
            top_if.flr_rqst <= {N_FLOORS{1'b0}};
        end
        
    endtask //SEND_REQUEST

    initial begin
        $vcdpluson;
        reset = 1'b1;
        SEND_REQUEST(1,NULL);
        top_if.force_open = 1'b0;
        #10 reset = 1'b0;
        // Start of stimuli
        SEND_REQUEST(1,STOP);
        #1000;
        SEND_REQUEST(3,UP);
        #100;
        SEND_REQUEST(11,STOP);
        #2000;
        SEND_REQUEST(2,DN);
        #4000;
        SEND_REQUEST(9,DN);
        #3000;
        SEND_REQUEST(6,STOP);
        #10000;
        SEND_REQUEST(1,DN);
        #1500;
        SEND_REQUEST(7,UP);
        #300;
        SEND_REQUEST(1,STOP);
        #3000;
        SEND_REQUEST(9,DN);
        #2000;
        SEND_REQUEST(10,DN);
        #2000;
        SEND_REQUEST(1,STOP);
        #30000;
        $finish;
    end

    initial begin
        clk = 1'b0;
        forever begin
            #1 clk = ~clk;
        end
    end

    // Very basic checker
    generate
        genvar i;
        for(i = 0; i < N_FLOORS; i = i + 1) begin : u2
            initial begin
                forever begin
                    @(posedge top_if.floor_sense[i]);
                    $display("Currently lift is at floor : %d", i+1);
                end
            end
        end
    endgenerate


    initial begin
        forever begin
            @(posedge top_if.door_open);
            $display("Door opens");
        end
        forever begin
            @(posedge top_if.door_open);
            $display("Door closes");
        end
    end

endmodule

`endif