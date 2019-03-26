//===--- CrossPlatform.cpp -----------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2018 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "IndexStoreDB/Support/CrossPlatform.h"
#include "IndexStoreDB/Support/LLVM.h"
#include "llvm/Support/ConvertUTF.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/ArrayRef.h"

namespace IndexStoreDB {
namespace xplat {
indexstorePid_t getpid() {
#if defined(_WIN32)
    return GetCurrentProcess();
#else
    return getpid();
#endif
}

bool isProcessStillExecuting(indexstorePid_t PID) {
#if defined(_WIN32)
  DWORD exitCode;
  bool result = GetExitCodeProcess(PID, &exitCode);
  return result && (exitCode == STILL_ACTIVE);
#else
  return !(getsid(PID) == -1 && errno == ESRCH)
#endif
}

char* realpath(const char *path, char *resolved_path) {
#if defined(_WIN32)
    SmallVector<llvm::UTF16, 30> u16Path;
    llvm::convertUTF8ToUTF16String(path, u16Path);
    HANDLE f = CreateFileW(
        /*lpFileName*/(LPCWSTR)u16Path.data(),
        /*dwDesiredAccess*/0,
        /*dwShareMode*/FILE_SHARE_WRITE,
        /*lpSecurityAttributes*/NULL,
        /*dwCreationDisposition*/OPEN_EXISTING,
        /*dwFlagsAndAttributes*/FILE_ATTRIBUTE_NORMAL,
        /*hTemplateFile*/NULL);
    if (f == INVALID_HANDLE_VALUE) {
        return NULL;
    }
    DWORD pathSize = GetFinalPathNameByHandleW(f, NULL, 0, 0);
    WCHAR *u16ResolvedPath = (WCHAR*)malloc(sizeof(WCHAR)* pathSize);
    DWORD result = GetFinalPathNameByHandleW(f, u16ResolvedPath, pathSize, 0);
    if (result == 0) {
        return NULL;
    }
    std::string u8ResolvedPath;
    llvm::convertUTF16ToUTF8String(llvm::ArrayRef<llvm::UTF16>((llvm::UTF16*)u16ResolvedPath, pathSize), u8ResolvedPath);
    if (resolved_path == NULL) {
        resolved_path = (char *)malloc(u8ResolvedPath.size() * sizeof(char));
    }
    u8ResolvedPath.copy(resolved_path, u8ResolvedPath.size());
    free(u16ResolvedPath);
    return resolved_path;
#else
    return realpath(path, resolved_path);
#endif
}

}
}
