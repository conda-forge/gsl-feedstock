#!/bin/bash

# https://github.com/conda-forge/toolchain-feedstock/pull/11
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
export LD_LIBRARY_PATH="${PREFIX}/lib:${LD_LIBRARY_PATH}"

LIBS="-lopenblas -lm" ./configure --prefix=$PREFIX || cat config.log

make
make check
make install
