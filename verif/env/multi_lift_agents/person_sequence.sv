`ifndef PERSON_SEQUENCE
`define PERSON_SEQUENCE

class person_sequence extends uvm_sequence#(person_journey_item);
    `uvm_object_utils(person_sequence)

    function new(string name = "person_sequence");
        super.new(name);
    endfunction

    virtual task body();
        person_journey_item journey = person_journey_item::type_id::create("journey");

        // Objections are handled by the parent sequence or the test
        `uvm_info(get_type_name(), "Starting person sequence", UVM_HIGH)

        if(!journey.randomize() with { person_id == this.get_inst_id() % 256; }) begin
            `uvm_error(get_type_name(), "Randomization failed")
        end

        // Start the journey
        `uvm_do(journey)

        `uvm_info(get_type_name(), $sformatf("Person %0d finished journey: %0d -> %0d (Lift %0d)",
                  journey.person_id, journey.src_floor, journey.dest_floor, journey.boarded_lift_id), UVM_LOW)
    endtask
endclass

`endif
