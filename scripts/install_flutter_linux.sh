#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.24.5"
ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${ARCHIVE}"
INSTALL_DIR="${HOME}/flutter"

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required but not installed." >&2
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "Error: tar is required but not installed." >&2
  exit 1
fi

cd "${HOME}"

echo "Downloading Flutter ${FLUTTER_VERSION}..."
curl -fL -o "${ARCHIVE}" "${URL}"

rm -rf "${INSTALL_DIR}"
echo "Extracting SDK to ${INSTALL_DIR}..."
tar xf "${ARCHIVE}"
rm -f "${ARCHIVE}"

if ! grep -q 'export PATH="$HOME/flutter/bin:$PATH"' "${HOME}/.bashrc"; then
  echo 'export PATH="$HOME/flutter/bin:$PATH"' >> "${HOME}/.bashrc"
fi

export PATH="$HOME/flutter/bin:$PATH"

echo "Installed. Run: source ~/.bashrc"
flutter --version
