#!/usr/bin/env bash
set -Eeuo pipefail

# Test installer for a single Pressable WordPress site.
# Run this from the WordPress root (the directory containing wp-content).
# It does not download files or touch environment variables.

PLUGIN_NAME="pressable-mu-test.php"
SOURCE_FILE="./${PLUGIN_NAME}"
MU_DIR="./wp-content/mu-plugins"
DEST="${MU_DIR}/${PLUGIN_NAME}"

if [[ ! -d "./wp-content" ]]; then
  echo "ERROR: ./wp-content was not found."
  echo "Run this script from the WordPress installation root."
  echo "Current directory: $PWD"
  exit 1
fi

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "ERROR: $SOURCE_FILE was not found beside this script."
  echo "Upload pressable-mu-test.php to the same directory as this script."
  exit 1
fi

mkdir -p "$MU_DIR"

if [[ -f "$DEST" ]]; then
  cp -p "$DEST" "${DEST}.backup.$(date +%Y%m%d%H%M%S)"
fi

install -m 0644 "$SOURCE_FILE" "$DEST"

if ! grep -q "Pressable MU-plugin deployment test is loaded" "$DEST"; then
  echo "ERROR: Installed file verification failed."
  exit 1
fi

echo "SUCCESS: Installed $DEST"
echo "Next: sign in to WordPress as an administrator and check the dashboard for:"
echo "Pressable MU-plugin deployment test is loaded."
