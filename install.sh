#!/bin/bash
# JARVIS one-command installer for macOS (installs the built release, not source).
# Usage: curl -fsSL https://huy100408.github.io/jarvis-install/install.sh | bash
set -euo pipefail

SITE="https://huy100408.github.io/jarvis-install"

for dir in /opt/homebrew/bin /usr/local/bin; do
  if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then export PATH="$dir:${PATH}"; fi
done

if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
  echo "JARVIS needs a Mac with Apple Silicon."
  exit 1
fi

need_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "$1 is required. Install Homebrew from https://brew.sh, then rerun this installer."
    exit 1
  fi
}

if ! command -v python3.12 >/dev/null 2>&1 && [ ! -x /opt/homebrew/opt/python@3.12/bin/python3.12 ]; then
  need_brew "Python 3.12"
  echo "Installing Python 3.12 via Homebrew..."
  brew install python@3.12
fi
if ! command -v node >/dev/null 2>&1; then
  need_brew "Node.js"
  echo "Installing Node.js via Homebrew..."
  brew install node
fi

TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT
echo "Downloading JARVIS..."
curl -fsSL -H "Cache-Control: no-cache" "${SITE}/latest.json" -o "${TMP}/latest.json"
FILE="$(plutil -extract file raw -o - "${TMP}/latest.json")"
WANT="$(plutil -extract sha256 raw -o - "${TMP}/latest.json")"
curl -fL --progress-bar "${SITE}/${FILE}" -o "${TMP}/jarvis.tar.gz"
GOT="$(shasum -a 256 "${TMP}/jarvis.tar.gz" | cut -d' ' -f1)"
if [ "${GOT}" != "${WANT}" ]; then
  echo "Download check failed (hash mismatch). Nothing was installed."
  exit 1
fi
mkdir "${TMP}/pkg"
tar -xzf "${TMP}/jarvis.tar.gz" -C "${TMP}/pkg"
bash "${TMP}/pkg/Jarvis/scripts/jarvis" install-package "${TMP}/pkg/Jarvis"
