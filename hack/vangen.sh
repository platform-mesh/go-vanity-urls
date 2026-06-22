#!/usr/bin/env bash
# Copyright 2026 The Platform Mesh Authors.
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

cd "$(dirname "$0")/.."

# Determine OS and architecture
GOOS="${GOOS:-$(go env GOOS 2>/dev/null || uname -s | tr '[:upper:]' '[:lower:]')}"
GOARCH="${GOARCH:-$(go env GOARCH 2>/dev/null || uname -m)}"

# Normalize architecture names
case "$GOARCH" in
  x86_64)
    GOARCH="amd64"
    ;;
  aarch64)
    GOARCH="arm64"
    ;;
esac

# Fetch the latest release version from Codeberg API
LATEST_VERSION=$(curl -sfL "https://codeberg.org/api/v1/repos/xrstf/vangen/releases/latest" | jq -r '.tag_name')
if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
  echo "Error: Failed to determine latest vangen release version." >&2
  exit 1
fi

VERSION="${LATEST_VERSION#v}" # Remove leading 'v' for filename

echo "Downloading vangen ${LATEST_VERSION} for ${GOOS}/${GOARCH}..."

# Create temporary directory
TMPDIR=$(mktemp -d)
trap "rm -rf '$TMPDIR'" EXIT

# Download and extract vangen
ARCHIVE="vangen_${VERSION}_${GOOS}_${GOARCH}.tar.gz"
DOWNLOAD_URL="https://codeberg.org/xrstf/vangen/releases/download/${LATEST_VERSION}/${ARCHIVE}"

curl -sfL "$DOWNLOAD_URL" -o "$TMPDIR/$ARCHIVE"
tar -xzf "$TMPDIR/$ARCHIVE" -C "$TMPDIR"

VANGEN_BIN="$TMPDIR/vangen_${VERSION}_${GOOS}_${GOARCH}/vangen"

echo "Generating vanity URL pages..."
"$VANGEN_BIN" -o .

echo "Done."
