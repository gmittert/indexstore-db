add_library(Index
    FilePathIndex.cpp
    FileVisibilityChecker.cpp
    IndexDatastore.cpp
    IndexStoreLibraryProvider.cpp
    IndexSystem.cpp
    StoreSymbolRecord.cpp
    SymbolIndex.cpp
    )
target_include_directories(CIndexStoreDB PUBLIC ${PROJECT_SOURCE_DIR}/include)
