add_swift_executable(tibs
  SOURCES
  main.swift
  TARGET
  ${CMAKE_C_COMPILER_TARGET}
  CFLAGS
  ${deployment_target}
  LINK_FLAGS
  ${libdispatch_ldflags}
  ${foundation_ldflags}
  -L ${CMAKE_BINARY_DIR}/lib
  SWIFT_FLAGS
  ${libdispatch_cflags}
  ${foundation_cflags}
  -I ${CMAKE_BINARY_DIR}/swift
  DEPENDS
  IndexStoreDB
  ISDBTibs
  )
