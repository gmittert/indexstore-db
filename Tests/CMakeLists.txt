add_subdirectory(ISDBTibsTests)
add_subdirectory(IndexStoreDBTests)

add_swift_executable(TestIndexStoreDB
  SOURCES
  main.swift
  TARGET
  ${CMAKE_C_COMPILER_TARGET}
  CFLAGS
  ${deployment_target}
  LINK_FLAGS
  ${libdispatch_ldflags}
  ${foundation_ldflags}
  ${xctest_ldflags}
  -L ${CMAKE_BINARY_DIR}/lib
  -lCIndexStoreDB
  SWIFT_FLAGS
  ${libdispatch_cflags}
  ${foundation_cflags}
  ${xctest_cflags}
  -I ${CMAKE_BINARY_DIR}/swift
  -I;${CMAKE_SOURCE_DIR}/include/CIndexStoreDB
  DEPENDS
  ISDBTibsTests
  IndexStoreDBTests
  )
