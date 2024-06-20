#!/bin/bash

mkdir build && cd build

# Use environment variables set by conda to detect build variants
if [[ "$blas_impl" == "mkl" ]]; then
    echo "Building with MKL support"
    BLAS_OPTION="Intel10_64lp_seq"
else
    echo "Building with OpenBLAS/LAPACK support"
    BLAS_OPTION="Generic"
fi

cmake \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DENABLE_CADET_MEX=OFF \
    -DBLA_VENDOR=$BLAS_OPTION \
    -DCMAKE_BUILD_TYPE=Release \
    ..
make install -j $CPU_COUNT
