#!/bin/sh
set -e -x

pwd
ls -all

# Install system packages required to build liblsl
apk update && apk add cmake linux-headers patchelf git ninja g++ make

# Get and build liblsl
git clone https://github.com/sccn/liblsl.git
cd liblsl
git checkout 1.13.0-b5
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=../../pylsl/ -DLSL_UNIXFOLDERS=ON -DLSL_SO_LINKS_STDCPP_STATIC=ON -DCMAKE_BUILD_TYPE=Debug ..
make install -j16
cd ../..
patchelf --set-rpath '$ORIGIN' pylsl/lib/liblsl64*.so.*
cp -L /lib/libc.musl-x86_64.so.1 pylsl/lib/
