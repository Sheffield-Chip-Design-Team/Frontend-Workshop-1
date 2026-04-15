#!/usr/bin/env bash
set -euo pipefail

# Must be run from a directory named exactly "workspace" (workspace root)
if [[ "$(basename -- "$PWD")" != "workspace" ]]; then
  echo "Error: run this script from the 'workspace' directory (not a subdirectory)." >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

TARGET="${TARGET:-cocotb_top}"
CORE_ID="sharc_example_ip_up_down_counter_1.0.0"
OUTPUT_DIR="$SCRIPT_DIR/../../sim"

# Relative path from this script to workspace/build
REL_BUILD_ROOT="${REL_BUILD_ROOT:-../../../build}"

BUILD_ROOT="$SCRIPT_DIR/$REL_BUILD_ROOT"
CFG_PATH="$BUILD_ROOT/$CORE_ID/$TARGET/$CORE_ID.eda.yml"

coral config up_down_counter -t "$TARGET"
sleep 1

if [[ ! -f "$CFG_PATH" ]]; then
  echo "Error: expected config not found at: $CFG_PATH" >&2
  echo "Hint: check core/target names and whether 'coral config' generated build artifacts." >&2
  exit 1
fi

coral sim -c "$CFG_PATH" --waves --exe verilator --verbose -o ./sim