#!/usr/bin/env bash
set -eo pipefail

IPA_PATH="${1:-}"
API_KEY="${APP_STORE_CONNECT_KEY_ID:-NT53237CZM}"
API_ISSUER="${APP_STORE_CONNECT_ISSUER_ID:-}"
P8_PATH="${APP_STORE_CONNECT_PRIVATE_KEY_PATH:-$HOME/Downloads/AuthKey_${API_KEY}.p8}"

# If no IPA path provided, locate the newest one in build/ios/ipa
if [ -z "$IPA_PATH" ]; then
  IPA_PATH=$(find build/ios/ipa -name "*.ipa" 2>/dev/null | head -n 1 || true)
fi

if [ -z "$IPA_PATH" ] || [ ! -f "$IPA_PATH" ]; then
  echo "Error: No IPA file found. Please run 'flutter build ipa' first, or pass the path to .ipa as the first argument."
  exit 1
fi

if [ -z "$API_ISSUER" ]; then
  echo "Error: APP_STORE_CONNECT_ISSUER_ID is not set."
  echo "Usage: APP_STORE_CONNECT_ISSUER_ID=<uuid> scripts/upload_testflight.sh [path/to/app.ipa]"
  echo "You can find your Issuer ID in App Store Connect -> Users and Access -> Integrations."
  exit 1
fi

if [ ! -f "$P8_PATH" ]; then
  # Check if in standard directory
  if [ -f "$HOME/.appstoreconnect/private_keys/AuthKey_${API_KEY}.p8" ]; then
    P8_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_${API_KEY}.p8"
  else
    echo "Error: AuthKey_${API_KEY}.p8 not found at $P8_PATH or in ~/.appstoreconnect/private_keys/"
    exit 1
  fi
fi

echo "===================================================="
echo "App Store Connect TestFlight Deployer (xcrun altool)"
echo "===================================================="
echo "IPA:        $IPA_PATH"
echo "Key ID:     $API_KEY"
echo "Issuer ID:  $API_ISSUER"
echo "Key File:   $P8_PATH"
echo "===================================================="
echo ""

echo "Step 1/2: Validating IPA with App Store Connect..."
xcrun altool --validate-app \
  -f "$IPA_PATH" \
  --type ios \
  --api-key "$API_KEY" \
  --api-issuer "$API_ISSUER" \
  --p8-file-path "$P8_PATH" \
  --show-progress

echo "✓ Validation succeeded!"
echo ""
echo "Step 2/2: Uploading IPA to TestFlight..."
xcrun altool --upload-app \
  -f "$IPA_PATH" \
  --type ios \
  --api-key "$API_KEY" \
  --api-issuer "$API_ISSUER" \
  --p8-file-path "$P8_PATH" \
  --show-progress

echo ""
echo "🎉 Successfully uploaded to TestFlight!"
