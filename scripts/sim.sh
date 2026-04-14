#!/usr/bin/env bash
set -euo pipefail

TARGET="${TARGET:-cocotb_top}"
CORE_ID="sharc_example_ip_up_down_counter_1.0.0"

# Relative path from this script to workspace/build
REL_BUILD_ROOT="${REL_BUILD_ROOT:-../../../build}"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_ROOT="$(cd "$SCRIPT_DIR/$REL_BUILD_ROOT" && pwd)"
CFG_PATH="$BUILD_ROOT/$CORE_ID/$TARGET/$CORE_ID.eda.yml"

coral config up_down_counter -t "$TARGET"
sleep 1
coral sim -c "$CFG_PATH" --waves --exe verilator --verbose -o ./sim