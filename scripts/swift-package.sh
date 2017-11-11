#!/bin/sh

BUNDLE_PREFIX=jp.ez-net.local.swift


YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(date +"%d")
BUNDLE_IDENTIFIER="${BUNDLE_PREFIX}.${YEAR}${MONTH}${DAY}"
DISPLAY_NAME_SHORT="Local Swift Development Snapshot"
DISPLAY_NAME="${DISPLAY_NAME_SHORT} ${YEAR}-${MONTH}-${DAY}"
TOOLCHAIN_NAME="${TOOLCHAIN_VERSION}"
TOOLCHAIN_VERSION="swift-LOCAL-${YEAR}-${MONTH}-${DAY}-a"

SWIFT_INSTALL_DIR="${SRC_DIR}/swift-nightly-install"
SWIFT_INSTALLABLE_PACKAGE="${SRC_DIR}/${ARCHIVE}"
SWIFT_INSTALL_SYMROOT="${SRC_DIR}/swift-nightly-symroot"
SWIFT_TOOLCHAIN_DIR="/Library/Developer/Toolchains/${TOOLCHAIN_NAME}.xctoolchain"

../../swift-source/swift/utils/build-script --preset="buildbot_osx_package" \
install_destdir="${SWIFT_INSTALL_DIR}" \
installable_package="${SWIFT_INSTALLABLE_PACKAGE}" \
install_toolchain_dir="${SWIFT_TOOLCHAIN_DIR}" \
install_symroot="${SWIFT_INSTALL_SYMROOT}" \
symbols_package="${SYMBOLS_PACKAGE}" \
darwin_toolchain_bundle_identifier="${BUNDLE_IDENTIFIER}" \
darwin_toolchain_display_name="${DISPLAY_NAME}" \
darwin_toolchain_xctoolchain_name="${TOOLCHAIN_NAME}" \
darwin_toolchain_version="${DARWIN_TOOLCHAIN_VERSION}"
