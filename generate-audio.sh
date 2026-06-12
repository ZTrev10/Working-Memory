#!/bin/bash
# Run from the Working Memory directory: bash generate-audio.sh
# Requires macOS (uses built-in `say` and `afconvert`)

VOICE="Samantha"
RATE=145
mkdir -p audio

ITEMS=(
  cat dog bird fish frog wolf fox owl duck
  cow pig horse sheep ant crab shark hawk
  crow bat rat mouse lamb bull hen elk seal whale
  cup bowl plate fork knife spoon pot pan box bag
  book pen key lock door bed chair lamp clock ring
  belt boot shoe hat glove brush comb soap stone leaf
  branch seed vine bush log rope chain hook nail bell
  ball dart card coin gem bead silk wool thread
  bread cake pie soup rice corn nut fig plum
  grape lime peach egg milk cheese ham prawn
  hill cliff cave lake pond stream beach field barn bridge
  path gate tower shelf drum torch flag mask sword shield
  brick cloud flame glass grass iron match paint plank smoke
  snail spike spine stamp stick straw tent thorn trunk twig
  1 2 3 4 5 6 7 8 9
)

total=${#ITEMS[@]}
count=0
for item in "${ITEMS[@]}"; do
  count=$((count + 1))
  OUT="audio/${item}.m4a"
  if [ -f "$OUT" ]; then
    echo "[$count/$total] Skipping (exists): $item"
    continue
  fi
  echo "[$count/$total] Generating: $item"
  TMP="/tmp/wm_${item}.aiff"
  say -v "$VOICE" -r $RATE "$item" -o "$TMP"
  afconvert "$TMP" -d aac -f m4af -b 64000 "$OUT"
  rm -f "$TMP"
done

echo ""
echo "Done. $total audio files in ./audio/"
