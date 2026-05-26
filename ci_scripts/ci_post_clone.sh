#!/bin/bash
set -euo pipefail

cd "${CI_PRIMARY_REPOSITORY_PATH:-$(pwd)}"

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
