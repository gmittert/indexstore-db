add_subdirectory(lmdb)
add_library(Database STATIC
    Database.cpp
    DatabaseError.cpp
    ImportTransaction.cpp
    ReadTransaction.cpp
    )
target_link_libraries(Database lmdb LLVMSupport Support Core BlocksRuntime)
target_include_directories(Database PUBLIC ${PROJECT_SOURCE_DIR}/include)
