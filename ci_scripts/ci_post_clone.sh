#!/bin/bash
set -euo pipefail

cd "${CI_PRIMARY_REPOSITORY_PATH:-$(pwd)}"

install_npm_tarball() {
  package_name="$1"
  version="$2"
  tarball_url="$3"
  destination="node_modules/${package_name}"
  tmpdir="$(mktemp -d)"

  mkdir -p "$(dirname "${destination}")"
  rm -rf "${destination}"
  curl --fail --location --silent --show-error "${tarball_url}" | tar -xz -C "${tmpdir}"
  mv "${tmpdir}/package" "${destination}"
  rm -rf "${tmpdir}"
}

install_npm_tarball "@capacitor/core" "8.3.4" "https://registry.npmjs.org/@capacitor/core/-/core-8.3.4.tgz"
install_npm_tarball "@capacitor/ios" "8.3.4" "https://registry.npmjs.org/@capacitor/ios/-/ios-8.3.4.tgz"
install_npm_tarball "@capacitor/app" "8.1.0" "https://registry.npmjs.org/@capacitor/app/-/app-8.1.0.tgz"
install_npm_tarball "@capacitor/device" "8.0.2" "https://registry.npmjs.org/@capacitor/device/-/device-8.0.2.tgz"
install_npm_tarball "@capacitor/filesystem" "8.1.2" "https://registry.npmjs.org/@capacitor/filesystem/-/filesystem-8.1.2.tgz"
install_npm_tarball "@capacitor/preferences" "8.0.1" "https://registry.npmjs.org/@capacitor/preferences/-/preferences-8.0.1.tgz"
install_npm_tarball "@capacitor/push-notifications" "8.1.1" "https://registry.npmjs.org/@capacitor/push-notifications/-/push-notifications-8.1.1.tgz"
install_npm_tarball "@capacitor-community/privacy-screen" "8.0.0" "https://registry.npmjs.org/@capacitor-community/privacy-screen/-/privacy-screen-8.0.0.tgz"

pod install
