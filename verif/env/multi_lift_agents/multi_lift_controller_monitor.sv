`ifndef MULTI_LIFT_CONTROLLER_MONITOR
`define MULTI_LIFT_CONTROLLER_MONITOR

class multi_lift_controller_monitor #(parameter N_FLOORS = `NUM_FLOORS, parameter N_LIFTS = 10) extends uvm_monitor;
    virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS) vif;

    `uvm_component_utils(multi_lift_controller_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual multi_lift_controller_if #(N_FLOORS, N_LIFTS))::get(this, "", "multi_lift_controller_vif", vif)) begin
            `uvm_fatal(get_full_name(), "Virtual interface not found")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(vif.up_rqst or vif.dn_rqst);
            if (vif.up_rqst) `uvm_info(get_full_name(), $sformatf("Global UP request detected: %b", vif.up_rqst), UVM_LOW)
            if (vif.dn_rqst) `uvm_info(get_full_name(), $sformatf("Global DN request detected: %b", vif.dn_rqst), UVM_LOW)
        end
    endtask
endclass

`endif
