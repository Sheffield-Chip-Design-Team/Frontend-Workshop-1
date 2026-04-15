#!/usr/bin/env bash
set -euo pipefail

# Must be run from a directory named exactly "workspace" (workspace root)
if [[ "$(basename -- "$PWD")" != "workspace" ]]; then
	echo "Error: run this script from the 'workspace' directory (not a subdirectory)." >&2
	exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BUILD_DIR="$SCRIPT_DIR/../../../synth"
mkdir -p "$BUILD_DIR"

RTL_FILE="$SCRIPT_DIR/../hw/rtl/up_down_counter.sv"
DUT_TOP="up_down_counter"

if [[ ! -f "$RTL_FILE" ]]; then
	echo "Error: RTL file not found at: $RTL_FILE" >&2
	exit 1
fi

sv2v "$RTL_FILE" > "$BUILD_DIR/up_down_counter.v"

yosys -p "read_verilog $BUILD_DIR/up_down_counter.v; prep -top $DUT_TOP; write_json $BUILD_DIR/up_down_counter.json"

netlistsvg "$BUILD_DIR/up_down_counter.json" -o "$BUILD_DIR/up_down_counter.svg"

echo "Flow complete. Outputs:"
echo "  - $BUILD_DIR/up_down_counter.v"
echo "  - $BUILD_DIR/up_down_counter.json"
echo "  - $BUILD_DIR/up_down_counter.svg"
