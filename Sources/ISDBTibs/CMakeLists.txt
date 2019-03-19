add_swift_library(ISDBTibs
  SHARED
  MODULE_NAME
  ISDBTibs
  MODULE_LINK_NAME
  ISDBTibs
  MODULE_PATH
  ${CMAKE_BINARY_DIR}/swift/ISDBTibs.swiftmodule
  SOURCES
  Data.swift		       
  TibsBuilder.swift	 
  TibsToolchain.swift
  JSONCompilationDatabase.swift  
  TibsManifest.swift
  OutputFileMap.swift	       
  Process.swift
  Makefile.swift
  TibsResolvedTarget.swift
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
  )

add_custom_command(TARGET ISDBTibs POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_CURRENT_BINARY_DIR}/ISDBTibs.dll"
        "${CMAKE_BINARY_DIR}/bin/ISDBTibs.dll")

add_custom_command(TARGET ISDBTibs POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_CURRENT_BINARY_DIR}/ISDBTibs.lib"
        "${CMAKE_BINARY_DIR}/lib/ISDBTibs.lib")
