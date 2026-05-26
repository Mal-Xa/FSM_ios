#!/bin/bash
set -euo pipefail

cd "${CI_PRIMARY_REPOSITORY_PATH:-$(pwd)}"

export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! command -v npm >/dev/null 2>&1; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "error: npm is required, and Homebrew is not available to install Node.js." >&2
    exit 1
  fi

  echo "npm was not found; installing Node.js with Homebrew..."
  brew install node
fi

npm install --no-audit --no-fund --ignore-scripts --no-save --package-lock=false \
  @capacitor/core@8.3.4 \
  @capacitor/ios@8.3.4 \
  @capacitor/app@8.1.0 \
  @capacitor/device@8.0.2 \
  @capacitor/filesystem@8.1.2 \
  @capacitor/preferences@8.0.1 \
  @capacitor/push-notifications@8.1.1 \
  @capacitor-community/privacy-screen@8.0.0

pod install
