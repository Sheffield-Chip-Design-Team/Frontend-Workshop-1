#!/usr/bin/env bash
set -euo pipefail

log() {
	echo "[INFO] $1"
}

fail() {
	echo "[FAIL] $1"
	exit 1
}

log "Starting coraltb installation..."

if [[ -d coraltb/.git ]]; then
	log "Coraltb repo already exists, skipping clone"
else
	log "Cloning Coraltb repository"
	git clone https://github.com/Sheffield-Chip-Design-Team/Coraltb.git coraltb
fi

cd coraltb
log "Installing root Python requirements"
pip install -r requirements.txt

log "Installing coraltb in editable mode"
pip install -e .

log "Showing installed coraltb package metadata"
pip show coraltb

log "Verifying coral CLI"
if ! command -v coral >/dev/null 2>&1; then
	fail "'coral' command not found on PATH after installation. Hint: activate your venv (for example: source venv/bin/activate) and rerun this script."
fi

coral -h >/dev/null
log "Verification passed: coral -h"

log "Coral installed successfully"
