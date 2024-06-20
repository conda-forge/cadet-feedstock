mkdir build
cd build

:: Use environment variables set by conda to detect build variants
if "%blas_impl%" == "true" (
    echo Building with MKL support
    set "BLAS_OPTION=Intel10_64lp_seq"
) else (
    echo Building with OpenBLAS/LAPACK support
    set "BLAS_OPTION=Generic"
)

cmake ^
    -G "NMake Makefiles" ^
    -DCMAKE_PREFIX_PATH=%PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DENABLE_CADET_MEX=OFF ^
    -DBLA_VENDOR=%BLAS_OPTION% ^
    ..

nmake
nmake install

