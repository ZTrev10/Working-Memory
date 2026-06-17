#!/bin/bash
# Run from the Working Memory directory: bash generate-audio.sh
# Requires: pip3 install edge-tts

mkdir -p audio/male audio/female

ITEMS=(
  cat dog bird fish frog wolf fox owl duck
  cow pig horse sheep ant crab shark hawk
  crow bat rat mouse hen elk seal whale
  cup plate knife spoon pot box bag
  book pen key lock door bed chair lamp clock ring
  belt boot hat glove brush comb stone leaf
  branch seed bush log rope chain hook nail
  ball dart card coin gem silk wool thread
  bread cake pie soup rice corn nut fig plum
  grape peach egg milk cheese ham prawn
  hill cliff cave pond stream beach bridge
  shelf drum torch flag mask
  brick cloud flame grass iron match paint plank
  snail spike stamp stick straw tent twig
  1 2 3 4 5 6 7 8 9
)

total=${#ITEMS[@]}

echo "Generating Male (Christopher) voices..."
count=0
for item in "${ITEMS[@]}"; do
  count=$((count + 1))
  OUT="audio/male/${item}.mp3"
  if [ -f "$OUT" ]; then
    echo "  [$count/$total] Skipping: $item"
    continue
  fi
  echo "  [$count/$total] $item"
  edge-tts --voice en-US-ChristopherNeural --text "$item" --write-media "$OUT"
done

echo ""
echo "Generating Female (Jenny) voices..."
count=0
for item in "${ITEMS[@]}"; do
  count=$((count + 1))
  OUT="audio/female/${item}.mp3"
  if [ -f "$OUT" ]; then
    echo "  [$count/$total] Skipping: $item"
    continue
  fi
  echo "  [$count/$total] $item"
  edge-tts --voice en-US-JennyNeural --text "$item" --write-media "$OUT"
done

echo ""
echo "Done. $(($total * 2)) audio files generated."
