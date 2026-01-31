`ifndef MULTI_LIFT_CONTROLLER_ARBITER
`define MULTI_LIFT_CONTROLLER_ARBITER

module multi_lift_controller_arbiter #(parameter N_FLOORS=12, parameter N_LIFTS = 10) (
    multi_lift_controller_if top_if,
    lift_controller_if int_if [N_LIFTS-1:0]
);

    // Track last floor for each lift (to handle between-floors case)
    reg [N_FLOORS-1:0] last_floor [N_LIFTS-1:0];
    always @(posedge top_if.clk or posedge top_if.reset) begin
        if (top_if.reset) begin
            for (int i = 0; i < N_LIFTS; i++) last_floor[i] <= 1; // Default to floor 1
        end else begin
            for (int i = 0; i < N_LIFTS; i++) begin
                if (int_if[i].floor_sense != 0)
                    last_floor[i] <= int_if[i].floor_sense;
            end
        end
    end

    // Routing signals
    logic [N_FLOORS-1:0] up_rqst_router [N_LIFTS-1:0];
    logic [N_FLOORS-1:0] dn_rqst_router [N_LIFTS-1:0];

    // Helper to get decimal floor index
    function int to_dec(input [N_FLOORS-1:0] onehot);
        for (int i = 0; i < N_FLOORS; i++) begin
            if (onehot[i]) return i;
        end
        return 0;
    endfunction

    // Global status logic
    logic [N_FLOORS-1:0] agg_up_status;
    logic [N_FLOORS-1:0] agg_dn_status;

    always_comb begin
        agg_up_status = 0;
        agg_dn_status = 0;
        for (int i = 0; i < N_LIFTS; i++) begin
            agg_up_status |= int_if[i].up_rqst_status;
            agg_dn_status |= int_if[i].dn_rqst_status;
        end
    end

    always_comb begin
        // Initialize
        for (int i = 0; i < N_LIFTS; i++) begin
            up_rqst_router[i] = 0;
            dn_rqst_router[i] = 0;
        end

        for (int f = 0; f < N_FLOORS; f++) begin
            // UP requests
            if (top_if.up_rqst[f] && !agg_up_status[f]) begin
                int best_lift = -1;
                int min_dist = 1000;
                for (int i = 0; i < N_LIFTS; i++) begin
                    int cur_f = to_dec(last_floor[i]);
                    int dist;
                    bit eligible = 0;

                    // Nearest elevator moving in that direction and yet to reach that floor
                    if (int_if[i].motion && int_if[i].direction && cur_f <= f) begin
                        dist = f - cur_f;
                        eligible = 1;
                    end else if (!int_if[i].motion) begin
                        dist = (f > cur_f) ? (f - cur_f) : (cur_f - f);
                        dist = dist + N_FLOORS; // Penalty for idle
                        eligible = 1;
                    end

                    if (eligible && dist < min_dist) begin
                        min_dist = dist;
                        best_lift = i;
                    end
                end
                if (best_lift != -1) up_rqst_router[best_lift][f] = 1;
                else up_rqst_router[0][f] = 1; // Fallback to first lift
            end

            // DN requests
            if (top_if.dn_rqst[f] && !agg_dn_status[f]) begin
                int best_lift = -1;
                int min_dist = 1000;
                for (int i = 0; i < N_LIFTS; i++) begin
                    int cur_f = to_dec(last_floor[i]);
                    int dist;
                    bit eligible = 0;

                    if (int_if[i].motion && !int_if[i].direction && cur_f >= f) begin
                        dist = cur_f - f;
                        eligible = 1;
                    end else if (!int_if[i].motion) begin
                        dist = (f > cur_f) ? (f - cur_f) : (cur_f - f);
                        dist = dist + N_FLOORS;
                        eligible = 1;
                    end

                    if (eligible && dist < min_dist) begin
                        min_dist = dist;
                        best_lift = i;
                    end
                end
                if (best_lift != -1) dn_rqst_router[best_lift][f] = 1;
                else dn_rqst_router[0][f] = 1; // Fallback
            end
        end
    end

    // Connect to internal interfaces
    genvar i_gen;
    generate
        for (i_gen = 0; i_gen < N_LIFTS; i_gen = i_gen + 1) begin
            assign int_if[i_gen].up_rqst = up_rqst_router[i_gen];
            assign int_if[i_gen].dn_rqst = dn_rqst_router[i_gen];
        end
    endgenerate

    assign top_if.global_up_rqst_status = agg_up_status;
    assign top_if.global_dn_rqst_status = agg_dn_status;
    `ifdef DEBUG_INTERFACE
    assign top_if.up_rqst_status = agg_up_status;
    assign top_if.dn_rqst_status = agg_dn_status;
    `endif

endmodule

`endif
