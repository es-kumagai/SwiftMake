#!/bin/sh

SWIFTSOURCE=$1

mkdir ${SWIFTSOURCE}
pushd ${SWIFTSOURCE}

git clone git@github.com:apple/swift.git
./swift/utils/update-checkout --clone-with-ssh

popd

make repositories-update

