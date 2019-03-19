cmake_minimum_required(VERSION 3.4.3)

set(INDEXSTOREDB_PATH_TO_LIBDISPATCH_SOURCE S:\\swift-corelibs-libdispatch)
set(INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD S:\\b\\libdispatch)
set(INDEXSTOREDB_PATH_TO_FOUNDATION_SOURCE S:\\swift-corelibs-foundation)
set(INDEXSTOREDB_PATH_TO_FOUNDATION_BUILD S:\\b\\foundation)
list(APPEND CMAKE_MODULE_PATH
     "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")
include(SwiftSupport)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_COMPILER clang-cl)
set(CMAKE_CXX_COMPILER clang-cl)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)

if(CMAKE_SYSTEM_NAME STREQUAL Android OR CMAKE_SYSTEM_NAME STREQUAL Linux)
  set(deployment_target -DDEPLOYMENT_TARGET_LINUX)
elseif(CMAKE_SYSTEM_NAME STREQUAL Darwin)
  set(deployment_target -DDEPLOYMENT_TARGET_MACOSX)
elseif(CMAKE_SYSTEM_NAME STREQUAL FreeBSD)
  set(deployment_target -DDEPLOYMENT_TARGET_FREEBSD)
elseif(CMAKE_SYSTEM_NAME STREQUAL Windows)
  set(deployment_target -DDEPLOYMENT_TARGET_WINDOWS)
  set(WORKAROUND_SR9138 -Xlinker;-ignore:4217)
  set(WORKAROUND_SR9995 -Xlinker;-nodefaultlib:libcmt)
endif()


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fblocks")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fblocks")
add_compile_definitions(LLVM_ENABLE_CRASH_DUMPS=false)

option(INDEXSTOREDB_PATH_TO_LIBDISPATCH_SOURCE "Path to libdispatch source" "")
option(INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD "Path to libdispatch build" "")
option(INDEXSTOREDB_PATH_TO_FOUNDATION_SOURCE "Path to foundation source" "")
option(INDEXSTOREDB_PATH_TO_FOUNDATION_BUILD "Path to foundation build" "")

include_directories(${INDEXSTOREDB_PATH_TO_LIBDISPATCH_SOURCE})
link_directories(${INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD})
link_directories(${INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD}/src)
include_directories(S:\\compiler-rt\\lib\\BlocksRuntime)
include_directories(include)

add_subdirectory(${CMAKE_SOURCE_DIR}/lib/CIndexStoreDB)
add_subdirectory(${CMAKE_SOURCE_DIR}/lib/Core)
add_subdirectory(${CMAKE_SOURCE_DIR}/lib/Database)
add_subdirectory(${CMAKE_SOURCE_DIR}/lib/Index)
add_subdirectory(${CMAKE_SOURCE_DIR}/lib/LLVMSupport)
add_subdirectory(${CMAKE_SOURCE_DIR}/lib/Support)


set(libdispatch_cflags -I;${INDEXSTOREDB_PATH_TO_LIBDISPATCH_SOURCE};-I;${INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD}/src/swift;-Xcc;-fblocks)
set(libdispatch_ldflags -L;${INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD};-L;${INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD}/src;-ldispatch;-lswiftDispatch)
set(foundation_cflags -I;${INDEXSTOREDB_PATH_TO_FOUNDATION_SOURCE};-I;${INDEXSTOREDB_PATH_TO_FOUNDATION_BUILD}/swift;-Fsystem ${INDEXSTOREDB_PATH_TO_FOUNDATION_BUILD}/CoreFoundation-prefix/System/Library/Frameworks)
set(foundation_ldflags -L;${INDEXSTOREDB_PATH_TO_FOUNDATION_BUILD};-lfoundation)

add_swift_library(IndexStoreDB
  SHARED
  MODULE_NAME
  IndexStoreDB
  MODULE_LINK_NAME
  IndexStoreDB
  MODULE_PATH
  ${CMAKE_CURRENT_BINARY_DIR}/swift/IndexStoreDB.swiftmodule
  SOURCES
  Sources/IndexStoreDB/IndexStoreDB.swift
  TARGET
  ${CMAKE_C_COMPILER_TARGET}
  CFLAGS
  ${deployment_target}
  LINK_FLAGS
  ${libdispatch_ldflags}
  ${foundation_ldflags}
  -L${CMAKE_CURRENT_BINARY_DIR}/lib/CIndexStoreDB
  -lCIndexStoreDB
  SWIFT_FLAGS
  -I;${CMAKE_SOURCE_DIR}/include/CIndexStoreDB
  ${libdispatch_cflags}
  ${foundation_cflags}
  DEPENDS
  CIndexStoreDB
  )

add_swift_library(IndexStoreDBCXX
  SHARED
  MODULE_NAME
  IndexStoreDBCXX
  MODULE_LINK_NAME
  IndexStoreDBCXX
  MODULE_PATH
  ${CMAKE_CURRENT_BINARY_DIR}/swift/IndexStoreDBCXX.swiftmodule
  SOURCES
  Sources/IndexStoreDB/IndexStoreDB.swift
  TARGET
  ${CMAKE_C_COMPILER_TARGET}
  CFLAGS
  ${deployment_target}
  -I;${CMAKE_SOURCE_DIR}/include
  LINK_FLAGS
  ${libdispatch_ldflags}
  ${foundation_ldflags}
  -L${CMAKE_CURRENT_BINARY_DIR}/lib/Index
  -lIndex
  -L${CMAKE_CURRENT_BINARY_DIR}/lib/CIndexStoreDB
  -lCIndexStoreDB
  SWIFT_FLAGS
  -I;${CMAKE_SOURCE_DIR}/include/CIndexStoreDB
  -I;${CMAKE_SOURCE_DIR}/include
  ${libdispatch_cflags}
  ${foundation_cflags}
  DEPENDS
  Index
  CIndexStoreDB
  )
