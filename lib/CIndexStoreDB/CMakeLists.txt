add_library(CIndexStoreDB
    CIndexStoreDB.cpp
    )
add_dependencies(CIndexStoreDB Index)
target_include_directories(CIndexStoreDB PUBLIC ../../include)
target_link_libraries(CIndexStoreDB dispatch Index)
