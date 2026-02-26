#!/usr/bin/env bash
# record.sh
# Records the entire demo as a single asciinema cast.
# Produces: casts/demo.cast
# Safe to run multiple times (overwrites previous cast).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAST_DIR="$SCRIPT_DIR/casts"
CAST_FILE="$CAST_DIR/demo.cast"

mkdir -p "$CAST_DIR"

echo "🎬 Starter optagelse → $CAST_FILE"
echo "   Kører: demo-dansk-git.sh"
echo ""

# Single recording wrapping the entire demo.
# -q suppresses the "asciinema: recording ..." banner.
# -c runs the demo as a sub-process; recording stops when it exits.
asciinema rec -q -c "$SCRIPT_DIR/demo-dansk-git.sh" "$CAST_FILE"

echo ""
echo "✅ Optagelse gemt: $CAST_FILE"
