add_library(Support
    Concurrency-Mac.cpp
    FilePathWatcher.cpp
    Logging-NonMac.cpp
    Logging.cpp
    Path.cpp
    PatternMatching.cpp
    )
target_include_directories(Support PUBLIC ${PROJECT_SOURCE_DIR}/include)
