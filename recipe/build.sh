if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
  (
    mkdir -p build-host
    pushd build-host

    # Switch to build host compiler
    export CC=$CC_FOR_BUILD
    export CXX=$CXX_FOR_BUILD
    export LDFLAGS=${LDFLAGS//$PREFIX/$BUILD_PREFIX}
    export PKG_CONFIG_PATH=${PKG_CONFIG_PATH//$PREFIX/$BUILD_PREFIX}

    # Unset them as we're ok with builds that are either slow or non-portable
    unset CFLAGS
    unset CXXFLAGS

    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$BUILD_PREFIX -DCMAKE_INSTALL_PREFIX=$BUILD_PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_CADET_MEX=OFF \
      ..

    # No need to compile everything, just templateCodeGen is sufficient
    cmake --build . --target templateCodeGen --parallel ${CPU_COUNT} --config Release
  )
  EXTERNAL_TEMPLATE_CODEGEN=`realpath ./build-host/src/build-tools/templateCodeGen`
else
  # Fall back to compiling templateCodeGen as usual (target == build host)
  EXTERNAL_TEMPLATE_CODEGEN=""
fi

mkdir build && cd build
cmake \
    ${CMAKE_ARGS} \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_CADET_MEX=OFF \
    -DEXTERNAL_TEMPLATE_CODEGEN=$EXTERNAL_TEMPLATE_CODEGEN \
    ..
make install -j $CPU_COUNT
