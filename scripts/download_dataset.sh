#!/usr/bin/env bash
# Download, verify and unpack the MIR dataset into ./dataset
# Usage: bash scripts/download_dataset.sh   (run from anywhere)
set -euo pipefail

TAG="dataset-v1.0"
ZIP="MIR-dataset-v1.0.zip"
BASE="https://github.com/ibisma/DeGlare/releases/download/${TAG}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading ${ZIP} ..."
curl -fL -o "${TMP}/${ZIP}" "${BASE}/${ZIP}"
curl -fL -o "${TMP}/SHA256SUMS" "${BASE}/SHA256SUMS"

echo "Verifying checksum ..."
(cd "$TMP" && { command -v shasum >/dev/null && shasum -a 256 -c SHA256SUMS || sha256sum -c SHA256SUMS; })

echo "Unpacking into ${ROOT}/dataset ..."
unzip -q -o "${TMP}/${ZIP}" -d "$ROOT"
echo "Done."
