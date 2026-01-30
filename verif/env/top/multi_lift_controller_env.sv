`ifndef MULTI_LIFT_CONTROLLER_ENV
`define MULTI_LIFT_CONTROLLER_ENV

class multi_lift_controller_environment #(parameter N_FLOORS = `NUM_FLOORS, parameter N_LIFTS = 10) extends uvm_env;
    multi_lift_controller_agent #(N_FLOORS, N_LIFTS) multi_agent;
    lift_controller_agent single_agents[N_LIFTS];
    lift_controller_scoreboard scoreboards[N_LIFTS];

    `uvm_component_utils(multi_lift_controller_environment)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        multi_agent = multi_lift_controller_agent#(N_FLOORS, N_LIFTS)::type_id::create("multi_agent", this);

        for (int i = 0; i < N_LIFTS; i++) begin
            // Configure single agents to be passive and use specific interfaces
            uvm_config_db#(int)::set(this, $sformatf("single_agent_%0d", i), "is_active", UVM_PASSIVE);

            single_agents[i] = lift_controller_agent::type_id::create($sformatf("single_agent_%0d", i), this);
            scoreboards[i] = lift_controller_scoreboard::type_id::create($sformatf("sb_%0d", i), this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        for (int i = 0; i < N_LIFTS; i++) begin
            multi_agent.driver.lift_sb_ports[i].connect(scoreboards[i].input_txn_export);
            single_agents[i].monitor.output_txn_port.connect(scoreboards[i].output_txn_export);
        end
    endfunction
endclass

`endif
