add_swift_library(IndexStoreDB
  SHARED
  MODULE_NAME
  IndexStoreDB
  MODULE_LINK_NAME
  IndexStoreDB
  MODULE_PATH
  ${CMAKE_BINARY_DIR}/swift/IndexStoreDB.swiftmodule
  SOURCES
  IndexStoreDB.swift
  Symbol.swift
  SymbolLocation.swift
  SymbolOccurrence.swift
  SymbolRole.swift
  TARGET
  ${CMAKE_C_COMPILER_TARGET}
  CFLAGS
  ${deployment_target}
  LINK_FLAGS
  ${libdispatch_ldflags}
  ${foundation_ldflags}
  -L ${CMAKE_BINARY_DIR}/lib
  -lCIndexStoreDB
  SWIFT_FLAGS
  -I;${CMAKE_SOURCE_DIR}/include/CIndexStoreDB
  -I;${CMAKE_SOURCE_DIR}/include
  ${libdispatch_cflags}
  ${foundation_cflags}
  DEPENDS
  CIndexStoreDB
  )

add_custom_command(TARGET IndexStoreDB POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_CURRENT_BINARY_DIR}/IndexStoreDB.dll"
        "${CMAKE_BINARY_DIR}/bin/IndexStoreDB.dll")

add_custom_command(TARGET IndexStoreDB POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_CURRENT_BINARY_DIR}/IndexStoreDB.lib"
        "${CMAKE_BINARY_DIR}/lib/IndexStoreDB.lib")
