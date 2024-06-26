#!/bin/bash

mkdir -p build && cd build

#cmake -DCBLAS=no -DLAPACKE=no -DBUILD_TESTING=no -DBUILD_DOUBLE=no -DBUILD_COMPLEX=no -DBUILD_COMPLEX16=no -DLAPACKE_WITH_TMG=no -DCMAKE_Fortran_FLAGS="--fixed-form-infer --cpp-infer --implicit-interface --generate-object-code"  .. -DCMAKE_EXE_LINKER_FLAGS=-/Users/kerimbirgi/dev/lfortran/src/runtime/\ -llfortran_runtime\ -lm -DCMAKE_Fortran_COMPILER=/Users/kerimbirgi/dev/lfortran/src/bin/lfortran

cmake -DCBLAS=no -DLAPACKE=no -DBUILD_TESTING=no -DBUILD_DOUBLE=no -DBUILD_COMPLEX=no -DBUILD_COMPLEX16=no -DLAPACKE_WITH_TMG=no -DCMAKE_Fortran_FLAGS="--fixed-form-infer --cpp-infer --implicit-interface --generate-object-code"  .. -DCMAKE_EXE_LINKER_FLAGS=-L/Users/kerimbirgi/dev/lfortran/src/runtime/\ -llfortran_runtime\ -lm -DCMAKE_Fortran_COMPILER=/Users/kerimbirgi/dev/lfortran/src/bin/lfortran

cmake --build . -j --target install
