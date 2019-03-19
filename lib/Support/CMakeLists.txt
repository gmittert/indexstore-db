add_library(Support STATIC
    Concurrency-Mac.cpp
    CrossPlatform.cpp
    FilePathWatcher.cpp
    Logging-NonMac.cpp
    Logging.cpp
    Path.cpp
    PatternMatching.cpp
    )
add_dependencies(Support LLVMSupport)
target_link_libraries(Support LLVMSupport dispatch)
target_include_directories(Support PUBLIC ${PROJECT_SOURCE_DIR}/include)
