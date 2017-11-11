SWIFTSOURCE=${CURDIR}/swift-source
TOOLCHAIN_NAME=jp.ez-net.local.swift
TOOLCHAIN_DIST=./toolchains
LINUXSWIFT=swift-nightly-install
DIST_DEBUG=${SWIFTSOURCE}/build/Ninja-DebugAssert
SWIFT_DIST_DEBUG=${DIST_DEBUG}/swift-linux-x86_64/bin
SWIFTPM_DIST_DEBUG=${DIST_DEBUG}/swiftpm-linux-x86_64/debug
SWIFT_DOCDIR=${SWIFTSOURCE}/swift/docs

BUILDSCRIPT=${TIMEBIN} ${SWIFTSOURCE}/swift/utils/build-script
UPDATESCRIPT=${SWIFTSOURCE}/swift/utils/update-checkout
BUILDTOOLCHAIN=${TIMEBIN} ${SWIFTSOURCE}/swift/utils/build-toolchain
OPTIONS_LIBS=--foundation --libdispatch --xctest
OPTIONS_DEBUG=--debug-swift --debug-llvm --debug-lldb --debug-foundation --debug-libdispatch --debug-libicu --skip-ios --skip-tvos --skip-watchos --skip-build-freebsd --skip-build-cygwin --skip-build-osx --skip-build-ios --skip-build-tvos --skip-build-watchos --skip-build-android --skip-build-benchmarks
OPTIONS_RELEASE=-R
OPTIONS_SWIFTPM=--swiftpm --llbuild --xctest
OPTIONS_XCODE=-x --skip-build
OPTIONS_REPOS_UPDATE=--clone-with-ssh
OPTIONS_REPOS_RESET=--clone-with-ssh --reset-to-remote --scheme=master

STASH_FIND=${SWIFTSOURCE}/* -maxdepth 0 -path "${SWIFTSOURCE}/build" -prune -o -type d

ifeq ($(shell uname -s), Darwin)
TIMEBIN=/usr/bin/time
else
TIMEBIN=/usr/bin/time -f "\n\nTime: %E ([h:]m:s)\nUser: %U s\nSystem: %S s\nElapsed: %E s\nCPU %P\nPagefaults: major %F + minor %R\nSwaps: %W\n"
endif

all:
	${BUILDSCRIPT} ${OPTIONS_LIBS} ${OPTIONS_DEBUG}

swift:
	${BUILDSCRIPT} ${OPTIONS_DEBUG}

clean:
	${BUILDSCRIPT} ${OPTIONS_LIBS} ${OPTIONS_DEBUG} -c

clean-swift:
	${BUILDSCRIPT} ${OPTIONS_DEBUG} -c

test:
	${BUILDSCRIPT} ${OPTIONS_DEBUG} -t
	
test-all:
	${BUILDSCRIPT} ${OPTIONS_LIBS} ${OPTIONS_DEBUG} -t
	
release:
	${BUILDSCRIPT} ${OPTIONS_LIBS} ${OPTIONS_RELEASE} -t

xcode:
	${BUILDSCRIPT} ${OPTIONS_XCODE}

repositories-update:
	${UPDATESCRIPT} ${OPTIONS_REPOS_UPDATE}

repositories-reset:
	${UPDATESCRIPT} ${OPTIONS_REPOS_RESET}

toolchain:
	cd ${SWIFTSOURCE}
	${BUILDTOOLCHAIN} ${TOOLCHAIN_NAME}
	make toolchain-move

toolchain-move:
	@echo Moving Swift Toolchain.
	@mkdir -p ${TOOLCHAIN_DIST}
	@find ${SWIFTSOURCE}/swift -type f -name 'swift-LOCAL-*.tar.gz' -exec mv -f {} ${TOOLCHAIN_DIST}/ \;
	@echo Moving Swift Nightly Install
	@rm -rf ./${LINUXSWIFT}
	@mv -f ${SWIFTSOURCE}/swift/${LINUXSWIFT} ./

#foundation:
#	${BUILDSCRIPT} --foundation --lldb ${OPTIONS_DEBUG}

#libdispatch:
#	${BUILDSCRIPT} --libdispatch ${OPTIONS_DEBUG}

#playground:
#	${BUILDSCRIPT} --playgroundlogger --playgroundsupport ${OPTIONS_DEBUG}

swiftpm:
	${BUILDSCRIPT} ${OPTIONS_SWIFTPM} ${OPTIONS_DEBUG}
	make swiftpm-distribute

swiftpm-distribute:
	ln -fs ${SWIFTPM_DIST_DEBUG}/swift-* ${SWIFT_DIST_DEBUG}
	ln -fs ${SWIFTPM_DIST_DEBUG}/../.bootstrap/lib/swift/pm ${SWIFT_DIST_DEBUG}/../lib/swift

document:
	pushd ${SWIFTSOURCE}
	make -C ${SWIFT_DOCDIR} singlehtml
	popd

swift-init:
	./scripts/swift-init.sh "${SWIFTSOURCE}"

stash:
	@find ${STASH_FIND} -exec git -C {} stash \;

stash-pop:
	@find ${STASH_FIND} -exec git -C {} stash pop \;

