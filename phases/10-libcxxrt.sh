#!/bin/bash

set -e # make any subsequent failing command exit the script

cd `dirname $0`/..
export ROOT_DIR=`pwd`

. `dirname $0`/common.sh

prepare_project "libcxxrt" "https://github.com/pathscale/libcxxrt.git"

echo -e "\n### Running cmake"
cd "${SRCROOT}"
mkdir -p ${PROJECT}/build

${CMAKE} \
  -H"${SRCROOT}"/${PROJECT} \
  -B"${SRCROOT}"/${PROJECT}/build \
  -G"Ninja" \
  -DCMAKE_MAKE_PROGRAM=${NINJA} \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
  -DANDROID_ABI=${ABI_NAME} \
  -DANDROID_NDK=${ANDROID_NDK_HOME} \
  -DANDROID_PLATFORM=android-${ANDROID_API_LEVEL} \

cd ${PROJECT}/build

echo -e "\n### Building"
${NINJA}

echo -e "\n### Installing"
INSTALL_DIR="${INSTALL_PREFIX}/lib"
mkdir -p "${INSTALL_PREFIX}/lib"
cp "${SRCROOT}"/${PROJECT}/build/lib/libcxxrt.so ${INSTALL_DIR}
