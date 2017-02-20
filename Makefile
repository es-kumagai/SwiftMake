SWIFTSOURCE=../swift-source
TOOLCHAIN_NAME=jp.ez-net.local.swift
TOOLCHAIN_DIST=./toolchains
LINUXSWIFT=swift-nightly-install
DIST_DEBUG=~/swift-source/build/Ninja-DebugAssert
SWIFT_DIST_DEBUG=${DIST_DEBUG}/swift-linux-x86_64/bin
SWIFTPM_DIST_DEBUG=${DIST_DEBUG}/swiftpm-linux-x86_64/debug

TIMEBIN=/usr/bin/time -f "\n\nTime: %E ([h:]m:s)\nUser: %U s\nSystem: %S s\nElapsed: %E s\nCPU %P\nPagefaults: major %F + minor %R\nSwaps: %W\n"
BUILDSCRIPT=${TIMEBIN} ${SWIFTSOURCE}/swift/utils/build-script
BUILDTOOLCHAIN=${TIMEBIN} ${SWIFTSOURCE}/swift/utils/build-toolchain
OPTIONS_DEBUG=--skip-ios --skip-tvos --skip-watchos
OPTIONS_RELEASE=-R
OPTIONS_SWIFTPM=--swiftpm --llbuild --xctest

swift:
	${BUILDSCRIPT} ${OPTIONS_DEBUG}

clean:
	${BUILDSCRIPT} ${OPTIONS_DEBUG} -c

test:
	${BUILDSCRIPT} ${OPTIONS_DEBUG} -t
	
release:
	${BUILDSCRIPT} ${OPTIONS_RELEASE} -t

xcode:
	${BUILDSCRIPT} -x

toolchain:
	${BUILDTOOLCHAIN} ${TOOLCHAIN_NAME}
	make toolchain-move

toolchain-move:
	@echo Moving Swift Toolchain.
	@mkdir -p ${TOOLCHAIN_DIST}
	@find ${SWIFTSOURCE}/swift -type f -name 'swift-LOCAL-*.tar.gz' -exec mv -f {} ${TOOLCHAIN_DIST}/ \;
	@echo Moving Swift Nightly Install
	@rm -rf ./${LINUXSWIFT}
	@mv -f ${SWIFTSOURCE}/swift/${LINUXSWIFT} ./

swiftpm:
	${BUILDSCRIPT} ${OPTIONS_SWIFTPM} ${OPTIONS_DEBUG}
	make swiftpm-distribute

swiftpm-distribute:
	ln -fs ${SWIFTPM_DIST_DEBUG}/swift-* ${SWIFT_DIST_DEBUG}
	ln -fs ${SWIFTPM_DIST_DEBUG}/../.bootstrap/lib/swift/pm ${SWIFT_DIST_DEBUG}/../lib/swift

