#!/bin/bash

mkdir -p build && cd build

cmake .. -DCMAKE_Fortran_COMPILER=gfortran -DCBLAS=no -DLAPACKE=no -DBUILD_TESTING=no -DBUILD_DOUBLE=no -DBUILD_COMPLEX=no -DBUILD_COMPLEX16=no -DLAPACKE_WITH_TMG=no -DCMAKE_Fortran_PREPROCESS=yes -DCMAKE_INSTALL_LIBDIR=$HOME/ext/lapack
