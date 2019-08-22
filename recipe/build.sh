#!/bin/bash

# https://github.com/conda-forge/gsl-feedstock/issues/34#issuecomment-449305702
if [[ "$target_platform" == win* ]]; then
    export CPPFLAGS="$CPPFLAGS -DGSL_DLL -DWIN32"
    export CXXFLAGS="$CXXFLAGS -DGSL_DLL -DWIN32"
    export CFLAGS="$CFLAGS -DGSL_DLL -DWIN32"
    export LDFLAGS="$LDFLAGS -lcblas"
    cp $RECIPE_DIR/getopt.h .
    ./configure --prefix=${PREFIX} \
                --disable-static || (cat config.log && exit 1)
    cat config.log
else
    export LIBS="-lcblas -lm"
    ./configure --prefix=${PREFIX}  \
                --host=${HOST} || (cat config.log && exit 1)
fi

[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT} ${VERBOSE_AT}
make install

# Don't link with the convenience libraries as they don't contain __imp_*
if [[ "$target_platform" == win* ]]; then
    for f in $(find . -wholename "./*/.libs/*.lib" -not -wholename "./blas/*"  -not -wholename "./cblas/*"); do
        cp .libs/gsl.dll.lib $f
    done
fi

make check

ls -al "$PREFIX"/lib
ls -al "$PREFIX"/bin

if [[ "$target_platform" == osx* ]]; then
    ln -sf "libcblas.3.dylib" "$PREFIX/lib/libgslcblas.dylib"
    ln -sf "libcblas.3.dylib" "$PREFIX/lib/libgslcblas.0.dylib"
    rm "$PREFIX/lib/libcblas.3.dylib"
    touch "$PREFIX/lib/libcblas.3.dylib"
elif [[ "$target_platform" == linux* ]]; then
    ln -sf "libcblas.so.3" "$PREFIX/lib/libgslcblas.so"
    ln -sf "libcblas.so.3" "$PREFIX/lib/libgslcblas.so.0"
    rm "$PREFIX/lib/libcblas.so.3"
    touch "$PREFIX/lib/libcblas.so.3"
elif [[ "$target_platform" == linux* ]]; then
    rm "$PREFIX/lib/gslcblas.dll.lib"
    rm "$PREFIX/bin/gslcblas-0.dll"
    cp "$PREFIX/lib/cblas.lib" "$PREFIX/lib/gslcblas.lib"
fi
