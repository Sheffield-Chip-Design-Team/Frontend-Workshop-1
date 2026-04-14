#!/usr/bin/env bash
coral config up_down_counter -t cocotb_top
sleep 1
coral sim -c /Users/macbook/chip_dev/workshop-1-dev/workspace/build/sharc_example_ip_up_down_counter_1.0.0/cocotb_top/sharc_example_ip_up_down_counter_1.0.0.eda.yml --waves --exe verilator --verbose -o ./sim

# coral sim --dut up_down_counter --waves --exe verilator --verbose -o ./sim