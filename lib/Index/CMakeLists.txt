add_library(Index STATIC
    FilePathIndex.cpp
    FileVisibilityChecker.cpp
    IndexDatastore.cpp
    IndexStoreLibraryProvider.cpp
    IndexSystem.cpp
    StoreSymbolRecord.cpp
    SymbolIndex.cpp
    )

add_dependencies(Index Database)
target_link_libraries(Index Database)
target_include_directories(Index PUBLIC ${PROJECT_SOURCE_DIR}/include)
