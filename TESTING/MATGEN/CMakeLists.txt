#######################################################################
#  This is the makefile to create a library of the test matrix
#  generators used in LAPACK.  The files are organized as follows:
#
#     SCATGEN  -- Auxiliary routines called from single precision
#     DZATGEN  -- Auxiliary routines called from double precision
#     SMATGEN  -- Single precision real matrix generation routines
#     CMATGEN  -- Single precision complex matrix generation routines
#     DMATGEN  -- Double precision real matrix generation routines
#     ZMATGEN  -- Double precision complex matrix generation routines
#
#######################################################################

set(SCATGEN slatm1.f slatm7.f slaran.f slarnd.f)

set(SMATGEN slatms.f slatme.f slatmr.f slatmt.f
   slagge.f slagsy.f slakf2.f slarge.f slaror.f slarot.f slatm2.f
   slatm3.f slatm5.f slatm6.f slahilb.f)

set(CMATGEN clatms.f clatme.f clatmr.f clatmt.f
   clagge.f claghe.f clagsy.f clakf2.f clarge.f claror.f clarot.f
   clatm1.f clarnd.f clatm2.f clatm3.f clatm5.f clatm6.f clahilb.f)

set(DZATGEN dlatm1.f dlatm7.f dlaran.f dlarnd.f)

set(DMATGEN dlatms.f dlatme.f dlatmr.f dlatmt.f
   dlagge.f dlagsy.f dlakf2.f dlarge.f dlaror.f dlarot.f dlatm2.f
   dlatm3.f dlatm5.f dlatm6.f dlahilb.f)

set(ZMATGEN zlatms.f zlatme.f zlatmr.f zlatmt.f
  zlagge.f zlaghe.f zlagsy.f zlakf2.f zlarge.f zlaror.f zlarot.f
  zlatm1.f zlarnd.f zlatm2.f zlatm3.f zlatm5.f zlatm6.f zlahilb.f)


set(SOURCES)
if(BUILD_SINGLE)
  list(APPEND SOURCES ${SMATGEN} ${SCATGEN})
endif()
if(BUILD_DOUBLE)
  list(APPEND SOURCES ${DMATGEN} ${DZATGEN})
endif()
if(BUILD_COMPLEX)
  list(APPEND SOURCES ${CMATGEN} ${SCATGEN})
endif()
if(BUILD_COMPLEX16)
  list(APPEND SOURCES ${ZMATGEN} ${DZATGEN})
endif()
list(REMOVE_DUPLICATES SOURCES)

add_library(${TMGLIB}_obj OBJECT ${SOURCES})
set_target_properties(
  ${TMGLIB}_obj PROPERTIES
  POSITION_INDEPENDENT_CODE ON
  Fortran_PREPROCESS ON
  )

if(BUILD_INDEX64_EXT_API)
  if(NOT CMAKE_Fortran_COMPILER_ID MATCHES ${INDEX64_EXT_API_COMPILERS})
    message(STATUS "Build Index-64 API as extended API with _64 suffix: skipped (unsupported Fortran compiler)")
    # Disable extended API for MATGEN and LAPACK.
    set(BUILD_INDEX64_EXT_API OFF)
    set(BUILD_INDEX64_EXT_API OFF PARENT_SCOPE)
  else()
    cmake_minimum_required(VERSION 3.18)
    set(SOURCES_64)
    file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TMGLIB}_64_obj)
    file(COPY ${SOURCES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/${TMGLIB}_64_obj)
    file(GLOB SOURCES_64 ${CMAKE_CURRENT_BINARY_DIR}/${TMGLIB}_64_obj/*.*)
    foreach(F IN LISTS SOURCES_64)
      set(FFILE "")
      file(READ ${F} FFILE)
      file(WRITE ${F} "#include \"matgen_64.h\"\n")
      file(APPEND ${F} "${FFILE}")
    endforeach()
    file(COPY matgen_64.h DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/${TMGLIB}_64_obj)
    add_library(${TMGLIB}_64_obj OBJECT ${SOURCES_64})
    target_compile_options(${TMGLIB}_64_obj PRIVATE "${FOPT_ILP64}" -DMATGEN_64)
    set_target_properties(
    ${TMGLIB}_64_obj PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    Fortran_PREPROCESS ON
  )
  endif()
endif()

add_library(${TMGLIB}
        $<TARGET_OBJECTS:${TMGLIB}_obj>
        $<$<BOOL:${BUILD_INDEX64_EXT_API}>: $<TARGET_OBJECTS:${TMGLIB}_64_obj>>)

set_target_properties(
  ${TMGLIB} PROPERTIES
  VERSION ${LAPACK_VERSION}
  SOVERSION ${LAPACK_MAJOR_VERSION}
)

target_link_libraries(${TMGLIB} ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES})
lapack_install_library(${TMGLIB})
