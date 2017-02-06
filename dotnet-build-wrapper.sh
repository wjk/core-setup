#!/bin/sh

# These variables should be set by the script calling dotnet-build-wrapper.sh.
RID=$1
ARCH=$2

if [ "$RID" == "" -o "$ARCH" == "" ]; then
    echo "usage: $0 <target_rid> <target_arch>" 2>&1
    exit 1
fi

MY_DIR=$(cd $(dirname $0) && pwd)

set -e

mkdir -p $MY_DIR/bin/native
pushd $MY_DIR/bin/native > /dev/null
$MY_DIR/src/corehost/build.sh --rid $RID --arch $ARCH --hostver 1.0.0 --apphostver 1.0.0 --fxrver 1.0.0 --policyver 1.0.0 --commithash $(git rev-parse HEAD)
popd > /dev/null

mkdir -p $MY_DIR/bin/pkg
pushd $MY_DIR/bin/pkg > /dev/null
$MY_DIR/pkg/init-tools.sh
$MY_DIR/pkg/pack.sh
popd > /dev/null
