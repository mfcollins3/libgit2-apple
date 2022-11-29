#!/usr/bin/env bash

# Copyright 2022 Michael F. Collins, III
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restrictions, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# build.sh
#
# This program automated building libgit2 to be linked into an iOS or macOS
# application, or to be used by other libraries that may be linked into
# applications.
#
# Usage: build.sh

ROOT_PATH=$PWD

PLATFORMS="MAC MAC_ARM64 OS64 SIMULATOR64 SIMULATORARM64 MAC_CATALYST MAC_CATALYST_ARM64"
for PLATFORM in $PLATFORMS; do
    echo "Building libgit2 for $PLATFORM"

    rm -rf /tmp/libgit2
    cp -r External/libgit2 /tmp/

    pushd /tmp/libgit2 > /dev/null

    LOG=/tmp/libgit2-$PLATFORM.log
    rm -rf $LOG

    OUTPUT_PATH=$ROOT_PATH/build/$PLATFORM
    rm -rf $OUTPUT_PATH

    case $PLATFORM in
        "MAC" )
            OPENSSL_ROOT_DIR=$ROOT_PATH/../openssl-apple/build/darwin64-x86_64
            ;;

        "MAC_ARM64" )
            OPENSSL_ROOT_DIR=$ROOT_PATH/../openssl-apple/build/darwin64-arm64
            ;;

        "OS64" )
            OPENSSL_ROOT_DIR=$ROOT_PATH/../openssl-apple/build/openssl-ios64
            ;;

        "SIMULATOR64" )
            OPENSSL_ROOT_DIR=$ROOT_PATH/../openssl-apple/build/openssl-iossimulator
            ;;

        "SIMULATORARM64" )
            OPENSSL_ROOT_DIR=$ROOT_PATH/../openssl-apple/build/openssl-iossimulator-arm
            ;;

        "MAC_CATALYST" )
            OPENSSL_ROOT_DIR=$ROOT_PATH/../openssl-apple/build/openssl-catalyst
            ;;

        "MAC_CATALYST_ARM64" )
            OPENSSL_ROOT_DIR=$ROOT_PATH/../openssl-apple/build/openssl-catalyst-arm
            ;;
    esac

    LIBSSH2_ROOT_DIR=$ROOT_PATH/../libssh2-apple/build/$PLATFORM

    mkdir bin
    cd bin
    cmake \
        -DCMAKE_TOOLCHAIN_FILE=$ROOT_PATH/External/ios-cmake/ios.toolchain.cmake \
        -DPLATFORM=$PLATFORM \
        -DCMAKE_INSTALL_PREFIX=$OUTPUT_PATH \
        -DOPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR \
        -DLIBSSH2_INCLUDE_DIR=$LIBSSH2_ROOT_DIR/include \
        -DLIBSSH2_LIBRARY=$LIBSSH2_ROOT_DIR/lib/libssh2.a \
        -DENABLE_BITCODE=FALSE \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_TESTS=OFF \
        -DUSE_SSH=ON \
        -DGIT_RAND_GETENTROPY=0 \
        -DBUILD_CLI=OFF \
        .. >> $LOG 2>&1
    cmake --build . --target install >> $LOG 2>&1

    popd > /dev/null
done

echo "Creating the universal library for macOS"

OUTPUT_PATH=$ROOT_PATH/build/macos
rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH
lipo -create \
    $ROOT_PATH/build/MAC/lib/libgit2.a \
    $ROOT_PATH/build/MAC_ARM64/lib/libgit2.a \
    -output $OUTPUT_PATH/libgit2.a

echo "Creating the universal library for iOS Simulator"

OUTPUT_PATH=$ROOT_PATH/build/iossimulator
rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH
lipo -create \
    $ROOT_PATH/build/SIMULATOR64/lib/libgit2.a \
    $ROOT_PATH/build/SIMULATORARM64/lib/libgit2.a \
    -output $OUTPUT_PATH/libgit2.a

echo "Creating the universal library for Catalyst"

OUTPUT_PATH=$ROOT_PATH/build/catalyst
rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH
lipo -create \
    $ROOT_PATH/build/MAC_CATALYST/lib/libgit2.a \
    $ROOT_PATH/build/MAC_CATALYST_ARM64/lib/libgit2.a \
    -output $OUTPUT_PATH/libgit2.a

echo "Creating the libssh2 XCFramework"

LIB_PATH=$ROOT_PATH
LIBSSH2_PATH=$LIB_PATH/libgit2.xcframework
rm -rf $LIBSSH2_PATH

xcodebuild -create-xcframework \
    -library $ROOT_PATH/build/macos/libgit2.a \
    -headers $ROOT_PATH/build/MAC/include \
    -library $ROOT_PATH/build/OS64/lib/libgit2.a \
    -headers $ROOT_PATH/build/OS64/include \
    -library $ROOT_PATH/build/iossimulator/libgit2.a \
    -headers $ROOT_PATH/build/SIMULATOR64/include \
    -library $ROOT_PATH/build/catalyst/libgit2.a \
    -headers $ROOT_PATH/build/MAC_CATALYST/include \
    -output $LIBSSH2_PATH

zip -r libgit2.zip libgit2.xcframework

echo "Done; cleaning up"
rm -rf $TEMP_PATH