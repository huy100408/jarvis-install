#!/bin/bash
# Remove Jarvis from this Mac completely.
#   curl -fsSL https://huy100408.github.io/jarvis-install/uninstall.sh | bash
#   jarvis uninstall [--yes] [--keep-data] [--dry-run]
# --keep-data  keep settings, sign-in and Keychain items (reinstall picks them up)
# --dry-run    only list what would be removed
# Python, Node and Homebrew are left alone: other apps may use them.
set -uo pipefail

YES=false KEEP=false DRY=false
for arg in "$@"; do
  case "$arg" in
    --yes|-y) YES=true ;;
    --keep-data) KEEP=true ;;
    --dry-run) DRY=true ;;
    *) echo "Unknown option: $arg (use --yes, --keep-data, --dry-run)"; exit 2 ;;
  esac
done

DEST="${HOME}/Documents/Jarvis"
APP="/Applications/Jarvis.app"
BUNDLE_ID="com.jarvis.autonomous.mac"
SUPPORT="${HOME}/Library/Application Support/JARVIS"

if [ -f "${DEST}/.jarvis-dev" ]; then
  echo "${DEST} is a development checkout (.jarvis-dev). Not removing anything."
  exit 1
fi

PROGRAM=()
# Only Jarvis's own app and commands: same-named things from elsewhere stay.
if [ "$(defaults read "${APP}/Contents/Info" CFBundleIdentifier 2>/dev/null)" = "${BUNDLE_ID}" ]; then
  PROGRAM+=("${APP}")
fi
for cmd in "${HOME}/.local/bin/jarvis" "/usr/local/bin/jarvis"; do
  grep -q "jarvis-install" "$cmd" 2>/dev/null && PROGRAM+=("$cmd")
done
# Only delete these folders when they are Jarvis installs (a VERSION file), never a same-named folder.
for d in "${DEST}" "${DEST}.previous"; do
  [ -f "$d/VERSION" ] && PROGRAM+=("$d")
done
PROGRAM+=(
  "${HOME}/Library/LaunchAgents/com.jarvis.bridge.plist"
  "${HOME}/Library/LaunchAgents/com.jarvis.server.plist"
  "/tmp/jarvis_server.log"
  "/tmp/jarvis_bridge.log"
  "${HOME}/Library/Caches/${BUNDLE_ID}"
  "${HOME}/Library/HTTPStorages/${BUNDLE_ID}"
  "${HOME}/Library/Saved Application State/${BUNDLE_ID}.savedState"
)
DATA=(
  "${SUPPORT}"
  "${HOME}/.jarvis"
  "${HOME}/.jarvis-credentials"
  "${HOME}/.config/jarvis"
  "${HOME}/Library/Preferences/${BUNDLE_ID}.plist"
)
KEYCHAIN=(com.jarvis.companion.auth com.jarvis.provider-settings com.jarvis.google-session com.jarvis.discord local.jarvis.bridge)

TARGETS=("${PROGRAM[@]}")
$KEEP || TARGETS+=("${DATA[@]}")

echo "Jarvis uninstaller"
echo
echo "Will remove:"
found=false
for p in "${TARGETS[@]}"; do
  if [ -e "$p" ] || [ -L "$p" ]; then echo "  $p"; found=true; fi
done
$found || echo "  (no Jarvis files found)"
if $KEEP; then
  echo "Keeping settings, sign-in and Keychain items (--keep-data)."
else
  echo "  Keychain items: ${KEYCHAIN[*]}"
  echo "  Privacy permissions granted to the Jarvis app"
fi
echo

if $DRY; then echo "Dry run: nothing was removed."; exit 0; fi

if ! $YES; then
  answer=""
  printf "Remove Jarvis now? Type yes to continue: "
  if ! { read -r answer < /dev/tty; } 2>/dev/null; then
    echo; echo "No terminal to confirm in. Re-run with --yes. Nothing was removed."; exit 1
  fi
  [ "$answer" = "yes" ] || { echo "Cancelled. Nothing was removed."; exit 0; }
fi

echo "Stopping Jarvis..."
for agent in com.jarvis.bridge com.jarvis.server; do
  launchctl bootout "gui/$(id -u)/${agent}" 2>/dev/null \
    || launchctl unload "${HOME}/Library/LaunchAgents/${agent}.plist" 2>/dev/null || true
done
pkill -f "jarvis_server serve" 2>/dev/null || true
pkill -f "dist/src/cli.js serve" 2>/dev/null || true
killall JarvisApp JarvisSetup 2>/dev/null || true
sleep 1

failed=()
for p in "${TARGETS[@]}"; do
  if [ -e "$p" ] || [ -L "$p" ]; then
    rm -rf "$p" 2>/dev/null || failed+=("$p")
  fi
done

if ! $KEEP; then
  for service in "${KEYCHAIN[@]}"; do
    for _ in $(seq 1 50); do
      security delete-generic-password -s "$service" >/dev/null 2>&1 || break
    done
  done
  tccutil reset All "${BUNDLE_ID}" >/dev/null 2>&1 || true
  defaults delete "${BUNDLE_ID}" >/dev/null 2>&1 || true
fi

echo
if [ ${#failed[@]} -gt 0 ]; then
  echo "Could not remove (needs your password or Finder):"
  for p in "${failed[@]}"; do echo "  $p"; done
  echo "Remove them with: sudo rm -rf <path>, or drag Jarvis from Applications to the Trash."
  exit 1
fi
echo "Jarvis was removed."
echo "Left in place: Python 3.12, Node.js and Homebrew (shared with other apps), and the"
echo "~/.local/bin PATH line in ~/.zshrc. Remove those yourself if nothing else needs them."
