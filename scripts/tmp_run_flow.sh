#!/usr/bin/env bash

set -euo pipefail

BUILD_DIR="build"
RTL_FILE="hw/rtl/up_down_counter.sv"
TB_FILE="hw/tb/up_down_counter_tb.sv"
TB_TOP="up_down_counter_tb"
DUT_TOP="up_down_counter"

mkdir -p "$BUILD_DIR"

verilator --timing --trace -Wall -Wno-fatal -Wno-WIDTHEXPAND -Wno-UNOPTFLAT --binary -sv \
  "$RTL_FILE" "$TB_FILE" \
  --top-module "$TB_TOP" --Mdir "$BUILD_DIR/verilator"

"$BUILD_DIR/verilator/V${TB_TOP}"

sv2v "$RTL_FILE" > "$BUILD_DIR/up_down_counter.v"

yosys -p "read_verilog $BUILD_DIR/up_down_counter.v; prep -top $DUT_TOP; write_json $BUILD_DIR/up_down_counter.json"

netlistsvg "$BUILD_DIR/up_down_counter.json" -o "$BUILD_DIR/up_down_counter.svg"

echo "Flow complete. Outputs:"
echo "  - $BUILD_DIR/up_down_counter.v"
echo "  - $BUILD_DIR/up_down_counter.json"
echo "  - $BUILD_DIR/up_down_counter.svg"
