add_library(CIndexStoreDB
    CIndexStoreDB.cpp
    )
add_dependencies(CIndexStoreDB Index)
target_include_directories(CIndexStoreDB PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(CIndexStoreDB PRIVATE dispatch Index)
