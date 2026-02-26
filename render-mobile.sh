#!/usr/bin/env bash
# render-mobile.sh
# Converts casts/demo.cast → final/mobile.mp4 (1080×1920 vertical, phone-friendly).
#
# Dependencies:
#   agg  (https://github.com/asciinema/agg)  – cast → gif/png frames
#   ffmpeg                                    – gif/frames → mp4
#
# Safe to run multiple times (overwrites previous output).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAST_FILE="$SCRIPT_DIR/casts/demo.cast"
FINAL_DIR="$SCRIPT_DIR/final"
TMP_GIF=$(mktemp /tmp/demo-XXXXXX.gif)
OUTPUT="$FINAL_DIR/mobile.mp4"

# Cleanup temp file on exit
trap 'rm -f "$TMP_GIF"' EXIT

# ── Validate inputs ────────────────────────────────────────────────────────────
if [[ ! -f "$CAST_FILE" ]]; then
  echo "❌ Kastfil ikke fundet: $CAST_FILE"
  echo "   Kør først: ./record.sh"
  echo "   Hvis optagelse fejler, installér asciinema:"
  echo "   sudo apt update && sudo apt install -y asciinema"
  exit 1
fi

for cmd in agg ffmpeg; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Manglende afhængighed: $cmd"
    if [[ "$cmd" == "ffmpeg" ]]; then
      echo "   Ubuntu: sudo apt update && sudo apt install -y ffmpeg"
    else
      echo "   Installér agg: https://github.com/asciinema/agg"
      echo "   (kræver typisk Rust/Cargo; fx: cargo install --locked agg)"
    fi
    exit 1
  fi
done

mkdir -p "$FINAL_DIR"

# ── Step 1: cast → GIF via agg ────────────────────────────────────────────────
echo "🎨 Konverterer cast → GIF (font-størrelse 26)..."
agg \
  --font-size 26 \
  --cols 60 \
  --rows 30 \
  "$CAST_FILE" \
  "$TMP_GIF"

# ── Step 2: GIF → vertical 1080×1920 MP4 via ffmpeg ──────────────────────────
echo "📱 Konverterer GIF → vertikal 1080×1920 MP4..."
ffmpeg -y \
  -i "$TMP_GIF" \
  -vf "
    scale=1080:-2:flags=lanczos,
    pad=1080:1920:(ow-iw)/2:(oh-ih)/2:color=black,
    format=yuv420p
  " \
  -c:v libx264 \
  -crf 18 \
  -preset slow \
  -movflags +faststart \
  "$OUTPUT"

echo ""
echo "✅ Mobilvideo gemt: $OUTPUT"
echo "   Opløsning: 1080×1920 (vertikal)"
