add_library(Core STATIC
    Symbol.cpp
    )
add_dependencies(Core LLVMSupport)
target_link_libraries(Core LLVMSupport)
target_include_directories(Core PUBLIC ../../include)
