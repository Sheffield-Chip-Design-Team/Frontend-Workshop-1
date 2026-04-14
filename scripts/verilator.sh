#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BUILD_DIR="$SCRIPT_DIR/../../../sim/verilator-sv/build"
RTL_FILE="$SCRIPT_DIR/../hw/rtl/up_down_counter.sv"
TB_FILE="$SCRIPT_DIR/../hw/tb/up_down_counter_tb.sv"

TB_TOP="up_down_counter_tb"

mkdir -p "$BUILD_DIR"

verilator --timing --trace -Wall -Wno-fatal -Wno-WIDTHEXPAND -Wno-UNOPTFLAT -Wno-TIMESCALEMOD --binary -sv \
  "$RTL_FILE" "$TB_FILE" \
  --top-module "$TB_TOP" --Mdir "$BUILD_DIR"

"$BUILD_DIR/V${TB_TOP}"

mkdir -p "$BUILD_DIR/results"
mv ./*.vcd "$BUILD_DIR/results/"
echo "Simulation complete. VCD file moved to $BUILD_DIR/results/"