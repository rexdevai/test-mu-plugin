#!/usr/bin/env bash
set -Eeuo pipefail

PLUGIN_URL="https://raw.githubusercontent.com/rexdevai/test-mu-plugin/main/pressable-mu-test.php"
WP_ROOT=""

# Detect WordPress root without relying on the current directory.
for path in /srv/htdocs /htdocs; do
  if [ -d "$path/wp-content" ]; then
    WP_ROOT="$path"
    break
  fi
done

if [ -z "$WP_ROOT" ]; then
  echo "ERROR: Could not locate WordPress root."
  exit 1
fi

echo "WordPress root detected: $WP_ROOT"

MU_DIR="$WP_ROOT/wp-content/mu-plugins"
DEST="$MU_DIR/pressable-mu-test.php"
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

echo "Downloading MU-plugin from GitHub..."

curl -fsSL --retry 2 "$PLUGIN_URL" -o "$TMP_FILE"

if ! grep -q "Pressable MU-plugin deployment test is loaded" "$TMP_FILE"; then
  echo "ERROR: Downloaded plugin failed validation."
  exit 1
fi

mkdir -p "$MU_DIR"

if [ -f "$DEST" ]; then
  cp -p "$DEST" "$DEST.backup.$(date +%Y%m%d%H%M%S)"
  echo "Existing plugin backed up."
fi

install -m 0644 "$TMP_FILE" "$DEST"

if cmp -s "$TMP_FILE" "$DEST"; then
  echo "SUCCESS: MU-plugin installed and verified at $DEST"
else
  echo "ERROR: Installed file verification failed."
  exit 1
fi
