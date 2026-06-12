#!/bin/bash
# Run from the Working Memory directory: bash generate-audio-elevenlabs.sh
# Free account at elevenlabs.io — API key found at elevenlabs.io/app/settings/api-keys

API_KEY="sk_b4aec22a64f531a34269fd8108af7c49a8aadce61e765191"

# Voice options (uncomment one):
VOICE_ID="21m00Tcm4TlvDq8ikWAM"  # Rachel — American female, clear and natural
# VOICE_ID="N2lVS1w4EtoT3dr4eOWO"  # Callum — American male
# VOICE_ID="JBFqnCBsd6RMkjVDRZzb"  # George — British male, warm
# VOICE_ID="IKne3meq5aSn9XLyUdCD"  # Charlie — Australian male

MODEL="eleven_turbo_v2"

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

  TMP="/tmp/wm_${item}.mp3"

  curl -s -X POST \
    "https://api.elevenlabs.io/v1/text-to-speech/${VOICE_ID}" \
    -H "xi-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"text\": \"${item}\",
      \"model_id\": \"${MODEL}\",
      \"voice_settings\": {
        \"stability\": 0.5,
        \"similarity_boost\": 0.75,
        \"style\": 0.0,
        \"use_speaker_boost\": true
      }
    }" \
    -o "$TMP"

  # Convert MP3 to M4A (same quality, smaller file)
  afconvert "$TMP" -d aac -f m4af -b 64000 "$OUT"
  rm -f "$TMP"

  # Respect API rate limits
  sleep 0.3
done

echo ""
echo "Done. $total audio files in ./audio/"
