#!/bin/bash

# https://github.com/conda-forge/toolchain-feedstock/pull/11
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
# https://github.com/conda-forge/toolchain-feedstock/pull/17
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
export LD_LIBRARY_PATH="${PREFIX}/lib:${LD_LIBRARY_PATH}"

LIBS="-lopenblas -lm" ./configure --prefix=$PREFIX

make
make check
make install
