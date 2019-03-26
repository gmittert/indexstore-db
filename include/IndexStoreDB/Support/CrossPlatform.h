//===--- CrossPlatform.h - Logging Interface --------------------------*- C++ -*-===//
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

#ifndef LLVM_INDEXSTOREDB_SUPPORT_CROSSPLATFORM_H
#define LLVM_INDEXSTOREDB_SUPPORT_CROSSPLATFORM_H

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>
#else
#include <unistd.h>
#endif


#if defined(_WIN32)
typedef HANDLE indexstorePid_t;
#define PATH_MAX MAX_PATH
#else
typedef pid_t indexstorePid_t;
#endif

namespace IndexStoreDB {
namespace xplat {
indexstorePid_t getpid();
bool isProcessStillExecuting(indexstorePid_t);
char* realpath(const char *path, char *resolved_path);
}
}

#endif
