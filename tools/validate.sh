#!/usr/bin/env bash
# Reproducible validation of every mrson schema against its example instances.
# Uses the JSON Structure reference tooling (structurize + json-structure SDK) in a local venv.
set -euo pipefail
cd "$(dirname "$0")/.."

VENV=".venv"
if [ ! -x "$VENV/bin/structurize" ]; then
  echo "· setting up $VENV (structurize + json-structure) ..."
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install --quiet --upgrade pip
  "$VENV/bin/pip" install --quiet structurize json-structure
fi
V="$VENV/bin/structurize"

fail=0
check() { # <schema> <instance>
  printf '  %-40s ' "$(basename "$2")"
  if "$V" validate --schema "$1" "$2" >/dev/null 2>&1; then echo "OK"; else echo "FAIL"; "$V" validate --schema "$1" "$2" 2>&1 | tail -1; fail=1; fi
}

echo "validating mrson schemas against examples:"
check schema/mrson-core.struct.json        examples/heart.mrson.json
check schema/mrson-core.struct.json        examples/cardiac-live.mrson.json
check schema/events.struct.json            examples/camera-modified.event.json
check schema/ops.struct.json               examples/recolor-segment.op.json
check schema/profiles/spatial.struct.json  examples/frames.spatial.json

if [ "$fail" -eq 0 ]; then echo "all valid ✓"; else echo "some invalid ✗"; exit 1; fi
