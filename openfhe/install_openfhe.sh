#!/bin/bash
# Arguments: (debug|release) (64|128)
BUILD=$1
NATIVEBIT=$2
 
REPOSITORY=openfhe-development
BRANCH=main
set -x

CC_OPENFHE="${CC_OPENFHE:=/usr/bin/gcc}"
CXX_OPENFHE="${CC_OPENFHE:=/usr/bin/g++}"
 
#installing OpenFHE
if [[ ! -d "/${REPOSITORY}" ]]
then
    cd / && git clone https://github.com/openfheorg/${REPOSITORY}.git
    git clone https://github.com/openfheorg/openfhe-python.git
    cd ${REPOSITORY}
    git checkout ${BRANCH}
    git submodule sync --recursive
    git submodule update --init  --recursive
fi
# -DWITH_NTL_ON -DCMAKE_BUILD_TYPE=Debug
# The comma converts to lowercase using "bash shell parameter expansion"
if [[ "${BUILD,}" == "debug" ]]
then
    CMAKE_BUILD=Debug
    # If it's debug, make runs repeatable by pinning the random number generator.
    sed -i.bak 's/\/\/ #define FIXED_SEED/#define FIXED_SEED/g' /${REPOSITORY}/src/core/include/math/distributiongenerator.h
    # The CMake script won't actually use debug unless you hack it.
    sed -i.bak 's/-O3/-O0/g' /${REPOSITORY}/CMakeLists.txt
    sed -i.bak 's/-Werror//g' /${REPOSITORY}/CMakeLists.txt
else
    CMAKE_BUILD=Release
fi
mkdir "/${REPOSITORY}/build"
cd "/${REPOSITORY}/build"
CC="${CC_OPENFHE}" CXX="${CXX_OPENFHE}" cmake \
    -DNATIVE_SIZE=$NATIVEBIT \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_BENCHMARKS=OFF \
    -DBUILD_UNITTESTS=OFF \
    -DWITH_OPENMP=ON \
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD} \
    ..
# Insist the compiler use only 1 process because this build will produce errors
# if more than one process is used simultaneously, as of Aug 2024.
make -j 1
make install
if [[ "${BUILD,}" == "release" ]]
then
    # Don't leave source code in your image.
    rm -rf "/${REPOSITORY}"
fi