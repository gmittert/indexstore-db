cmake_minimum_required(VERSION 3.4.3)
set(INDEXSTOREDB_PATH_TO_LIBDISPATCH_SOURCE S:\\swift-corelibs-libdispatch)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_COMPILER clang-cl)
set(CMAKE_CXX_COMPILER clang-cl)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fblocks")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fblocks")
add_compile_definitions(LLVM_ENABLE_CRASH_DUMPS=false)

option(INDEXSTOREDB_PATH_TO_LIBDISPATCH_SOURCE "Path to libdispatch source" "")
option(INDEXSTOREDB_PATH_TO_LIBDISPATCH_BUILD "Path to libdispatch build" "")

include_directories(${INDEXSTOREDB_PATH_TO_LIBDISPATCH_SOURCE})
include_directories(S:\\compiler-rt\\lib\\BlocksRuntime)
include_directories(include)

add_subdirectory(lib/CIndexStoreDB)
add_subdirectory(lib/Core)
add_subdirectory(lib/Database)
add_subdirectory(lib/Index)
add_subdirectory(lib/LLVMSupport)
add_subdirectory(lib/Support)
