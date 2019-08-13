//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import Foundation
#if os(Windows)
import WinSDK
#endif

/// The set of commandline tools used to build a tibs project.
public final class TibsToolchain {
  public let swiftc: URL
  public let clang: URL
  public let libIndexStore: URL
  public let tibs: URL
  public let ninja: URL?

  public init(swiftc: URL, clang: URL, libIndexStore: URL? = nil, tibs: URL, ninja: URL? = nil) {
    self.swiftc = swiftc
    self.clang = clang

#if os(Windows)
    let dylibFolder = "bin"
#else
    let dylibFolder = "lib"
#endif

    self.libIndexStore = libIndexStore ?? swiftc
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .appendingPathComponent("\(dylibFolder)/libIndexStore.\(TibsToolchain.dylibExt)", isDirectory: false)

    self.tibs = tibs
    self.ninja = ninja
  }

#if os(macOS)
  public static let dylibExt = "dylib"
#elseif os(Windows)
  public static let dylibExt = "dll"
#else
  public static let dylibExt = "so"
#endif

  public private(set) lazy var clangVersionOutput: String = {
    return try! Process.tibs_checkNonZeroExit(arguments: [clang.path, "--version"])
  }()

  public private(set) lazy var clangHasIndexSupport: Bool = {
    clangVersionOutput.starts(with: "Apple") || clangVersionOutput.contains("swift-clang")
  }()

  public private(set) lazy var ninjaVersion: (Int, Int, Int) = {
    precondition(ninja != nil, "expected non-nil ninja in ninjaVersion")
    var out = try! Process.tibs_checkNonZeroExit(arguments: [ninja!.path, "--version"])
    out = out.trimmingCharacters(in: .whitespacesAndNewlines)
    let components = out.split(separator: ".", maxSplits: 3)
    guard let maj = Int(String(components[0])),
      let min = Int(String(components[1])),
      let patch = components.count > 2 ? Int(String(components[2])) : 0
      else {
        fatalError("could not parsed ninja --version '\(out)'")
    }
    return (maj, min, patch)
  }()

  /// Sleep long enough for file system timestamp to change. For example, older versions of ninja
  /// use 1 second timestamps.
  public func sleepForTimestamp() {
    // FIXME: this method is very incomplete. If we're running on a filesystem that doesn't support
    // high resolution time stamps, we'll need to detect that here. This should only be done for
    // testing.
    var usec: UInt32 = 0
    var reason: String = ""
    if ninjaVersion < (1, 9, 0) {
      usec = 1_000_000
      reason = "upgrade to ninja >= 1.9.0 for high precision timestamp support"
    }

    if usec > 0 {
      let fsec = Float(usec) / 1_000_000
      fputs("warning: waiting \(fsec) second\(fsec == 1.0 ? "" : "s") to ensure file timestamp " +
            "differs; \(reason)\n", stderr)
#if os(Windows)
      Sleep(usec / 1000)
#else
      usleep(usec)
#endif
    }
  }
}

extension TibsToolchain {

  /// A toolchain suitable for using `tibs` for testing. Will `fatalError()` if we cannot determine
  /// any components.
  public static var testDefault: TibsToolchain {
    var swiftc: URL? = nil
    var clang: URL? = nil
    var tibs: URL? = nil
    var ninja: URL? = nil

    let fm = FileManager.default

    let envVar = "INDEXSTOREDB_TOOLCHAIN_PATH"
    if let path = ProcessInfo.processInfo.environment[envVar] {
      let bin = URL(fileURLWithPath: "\(path)/usr/bin", isDirectory: true)
      swiftc = bin.appendingPathComponent("swiftc", isDirectory: false)
      clang = bin.appendingPathComponent("clang", isDirectory: false)

      if !fm.fileExists(atPath: swiftc!.path) {
        fatalError("toolchain must contain 'swiftc' \(envVar)=\(path)")
      }
      if !fm.fileExists(atPath: clang!.path) {
        clang = nil // try to find by PATH
      }
    }

    if let ninjaPath = ProcessInfo.processInfo.environment["NINJA_BIN"] {
      ninja = URL(fileURLWithPath: ninjaPath, isDirectory: false)
    }

    var buildURL: URL? = nil
    #if os(macOS)
      // If we are running under xctest, the build directory is the .xctest bundle.
      for bundle in Bundle.allBundles {
        if bundle.bundlePath.hasSuffix(".xctest") {
          buildURL = bundle.bundleURL.deletingLastPathComponent()
          break
        }
      }
      // Otherwise, assume it is the main bundle.
      if buildURL == nil {
        buildURL = Bundle.main.bundleURL
      }
    #else
      buildURL = Bundle.main.bundleURL
    #endif

    if let buildURL = buildURL {
      tibs = buildURL.appendingPathComponent("tibs", isDirectory: false)
      if !fm.fileExists(atPath: tibs!.path) {
        tibs = nil // try to find by PATH
      }
    }

    swiftc = swiftc ?? findTool(name: "swiftc")
    clang = clang ?? findTool(name: "clang")
    tibs = tibs ?? findTool(name: "tibs")
    ninja = ninja ?? findTool(name: "ninja")

    guard swiftc != nil, clang != nil, tibs != nil, ninja != nil else {
      fatalError("""
        missing TibsToolchain component; had
          swiftc = \(swiftc?.path ?? "nil")
          clang = \(clang?.path ?? "nil")
          tibs = \(tibs?.path ?? "nil")
          ninja = \(ninja?.path ?? "nil")
        """)
    }

    return TibsToolchain(swiftc: swiftc!, clang: clang!, tibs: tibs!, ninja: ninja)
  }
}

/// Returns the path to the given tool, as found by `xcrun --find` on macOS, or `which` on Linux.
public func findTool(name: String) -> URL? {
#if os(macOS)
  let cmd = ["/usr/bin/xcrun", "--find", name]
#elseif os(Windows)
  var buf = [WCHAR](repeating: 0, count: Int(MAX_PATH))
  GetWindowsDirectoryW(&buf, DWORD(MAX_PATH))
  var wherePath = String(decodingCString: &buf, as: UTF16.self)
    .appendingPathComponent("system32")
    .appendingPathComponent("where.exe")
  let cmd = [wherePath, name]
#else
  let cmd = ["/usr/bin/which", name]
#endif

  guard var path = try? Process.tibs_checkNonZeroExit(arguments: cmd) else {
    return nil
  }
#if os(Windows)
  let paths = path.split { $0.isNewline }
  path = String(paths[0]).trimmingCharacters(in: .whitespacesAndNewlines)
#else
  if path.last == "\n" {
    path = String(path.dropLast())
  }
#endif
  return URL(fileURLWithPath: path, isDirectory: false)
}
