`ifndef MULTI_LIFT_TRAFFIC_SEQUENCE
`define MULTI_LIFT_TRAFFIC_SEQUENCE

class multi_lift_traffic_sequence #(parameter N_LIFTS = 10) extends uvm_sequence#(person_journey_item);

    `uvm_object_utils(multi_lift_traffic_sequence)

    function new(string name = "multi_lift_traffic_sequence");
        super.new(name);
    endfunction

    virtual task body();
        int n_people = `MAX_REQUESTS;
        person_journey_item results[$];

        `uvm_info(get_full_name(), $sformatf("Launching %0d parallel person sequences", n_people), UVM_LOW)

        for (int i = 0; i < n_people; i++) begin
            fork
                automatic int id = i;
                begin
                    person_sequence p_seq = person_sequence::type_id::create($sformatf("p_seq_%0d", id));
                    p_seq.start(m_sequencer, this);
                    // Collect results from the finished item
                    // (Actually, the item is updated in place by the driver)
                end
            join_none

            // Random delay between person arrivals
            #($urandom_range(100, 2000));
        end

        // Wait for all spawned sequences to finish
        wait fork;

        `uvm_info(get_full_name(), "All parallel person sequences completed", UVM_LOW)
    endtask

endclass

`endif
