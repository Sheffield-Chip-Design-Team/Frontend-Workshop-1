#!/usr/bin/env bash

set -euo pipefail

BUILD_DIR="build"
RTL_FILE="hw/rtl/updownCounter.sv"
TB_FILE="hw/tb/updownCounter_tb.sv"
TB_TOP="updownCounter_tb"
DUT_TOP="updownCounter"

mkdir -p "$BUILD_DIR"

verilator --timing --trace -Wall -Wno-fatal -Wno-WIDTHEXPAND -Wno-UNOPTFLAT --binary -sv \
  "$RTL_FILE" "$TB_FILE" \
  --top-module "$TB_TOP" --Mdir "$BUILD_DIR/verilator"

"$BUILD_DIR/verilator/V${TB_TOP}"

sv2v "$RTL_FILE" > "$BUILD_DIR/updownCounter.v"

yosys -p "read_verilog $BUILD_DIR/updownCounter.v; prep -top $DUT_TOP; write_json $BUILD_DIR/updownCounter.json"

netlistsvg "$BUILD_DIR/updownCounter.json" -o "$BUILD_DIR/updownCounter.svg"

echo "Flow complete. Outputs:"
echo "  - $BUILD_DIR/updownCounter.v"
echo "  - $BUILD_DIR/updownCounter.json"
echo "  - $BUILD_DIR/updownCounter.svg"
