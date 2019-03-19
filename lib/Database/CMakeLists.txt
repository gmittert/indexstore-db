add_subdirectory(lmdb)
add_library(Database STATIC
    Database.cpp
    DatabaseError.cpp
    ImportTransaction.cpp
    ReadTransaction.cpp
    )
add_dependencies(Database lmdb Support LLVMSupport Core)
target_link_libraries(Database ${CMAKE_CURRENT_BINARY_DIR}/lmdb/lmdb.lib LLVMSupport Support Core BlocksRuntime)

target_include_directories(Database PUBLIC ${PROJECT_SOURCE_DIR}/include)
