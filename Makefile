SWIFTSOURCE=~/swift-source
TOOLCHAIN_NAME=jp.ez-net.local.swift
TIMEBIN=/usr/bin/time -f "\n\nTime: %E ([h:]m:s)\nUser: %U s\nSystem: %S s\nElapsed: %E s\nCPU %P\nPagefaults: major %F + minor %R\nSwaps: %W\n"
BUILDSCRIPT=${TIMEBIN} ${SWIFTSOURCE}/swift/utils/build-script
BUILDTOOLCHAIN=${TIMEBIN} ${SWIFTSOURCE}/swift/utils/build-toolchain
OPTIONS_DEBUG=--skip-ios --skip-tvos --skip-watchos
OPTIONS_RELEASE=-R

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
	@find ${SWIFTSOURCE}/swift -type f -name 'swift-LOCAL-*.tar.gz' -exec mv {} ./toolchains \;
	@echo Moving Swift Nightly Install
	@find ${SWIFTSOURCE}/swift -type d -name 'swift-nightly-install' -exec mv {} . \;

