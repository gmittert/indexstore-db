add_subdirectory(lmdb)
add_library(Database
    Database.cpp
    DatabaseError.cpp
    ImportTransaction.cpp
    ReadTransaction.cpp
    )
add_dependencies(Core lmdb)
target_include_directories(Database PUBLIC ${PROJECT_SOURCE_DIR}/include)
