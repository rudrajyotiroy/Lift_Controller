# Lift Controller

This repository contains a project for a single elevator controller implemented in Verilog and verified using Universal Verification Methodology (UVM) framework.

## Project Structure

- **doc/**: Documentation for the project, which was essentially a theoretical assignment for course EC60291 : Architectural Design of ICs, which is a PG elective in IIT Kharagpur
- **log/**: Log files generated during simulation and synthesis.
- **rtl/**: Design Files
    - **lift_controller_if.sv**: interface for interacting with design
    - **request_handler.v**: sequential module responsible for storing all requests from people on different floors as well as people on the lift, and selectively clearing them when lift stops at a particular floor
    - **door_controller.v**: Door opening and counter based closing sequential logic based on asynchronous pulse
    - **main_alu_block.v**: Combinational logic block responsible for direction, motion control and indirect door control
    - **lift_controller_wrapper.sv**: Top design module for lift controller

- **tb/**: Testbench files for basic non UVM simulation
    - **lift_movement_emulator.sv**: Emulation module for lift movement. Controls the output observed by floor sensor switches as the lift moves through different floors, based on motion and direction
    - **tb_top.sv**: Non-UVM basic TestBench
    - **makefile**: Synopsis VCS makefile for basic TestBench

- **verif/**: Testbench files for UVM framework
    - **env/**
        - **agents/**
            - **lift_controller_cfg.sv**: Configuration randomization for request inputs
            - **lift_controller_seq_item.sv**: Repackaging of configuration inputs, for scoreboard purposes
            - **lift_controller_driver.sv**: Translation of requests through encoder and send copy to scoreboard (reference model is not used)
            - **lift_controller_monitor.sv**: Monitors door open and door close and decodes floor information, sends to scoreboard
            - **lift_controller_sequencer.sv**: Default
            - **lift_controller_agent.sv**: Default
            - **lift_controller_agent_pkg.sv**: Default
        - **top/**
            - **lift_controller_scoreboard.sv**: Out-of-order scoreboard that ticks off packets in input request array based on output packets
            - **lift_controller_env.sv**: Default
            - **lift_controller_env_pkg.sv**: Default
    - **tb/src**
            - **lift_movement_emulator.sv**: Emulation module for lift movement. Controls the output observed by floor sensor switches as the lift moves through different floors, based on motion and direction
            - **lift_controller_assertions.sv**: Assertions to validate constraints on floor position, motion, direction and door state
            - **tb_top.sv**: UVM Top Level TestBench, binds assertions
    - **sequence_lib/src**
            - **lift_controller_base_sequence.sv**: Send NUM_TRANSACTIONS number of stimulus inputs for a given operating condition, then wait for a given drain time before terminating, objection handling is done in here
            - **lift_controller_seq_pkg.sv**: Default package for this sequence
    - **tests/src**
            - **lift_controller_base_test.sv**: Base test for the given sequence, no objections raised
            - **lift_controller_test_pkg.sv**: Default package for this test

## Getting Started

### Prerequisites

This project was compiled, elaborated and tested on Xilinx Vivado 2021.2 using UVM 1.2 package

### Running Simulations

Please follow the instructions from this article for Xilinx Vivado
https://support.xilinx.com/s/article/1070861?language=en_US

For non-GUI simulation, please follow README.txt in vivado_sim directory

Synopsis VCS support to be added later

Current Status : Compile, Elaboration and Simulation is clean but assertion and scoreboard errors yet to be fixed

## Contributing

I shall add support for multiple elevators in future
Please feel free to create more testcases, scenarios, assertions and any creative changes
To start with, please open an issue or create a Pull Request

## Contact

For any inquiries, please contact [rudrajyotiroy](https://github.com/rudrajyotiroy) or send a mail to rudrajyotiroy@gmail.com

Have Fun!