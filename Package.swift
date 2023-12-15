// swift-tools-version:5.5
import PackageDescription

var exclude: [String] = []

#if os(Linux)
// Linux doesn't support CoreML, and will attempt to import the coreml source directory
exclude.append("coreml")
#endif

let package = Package(
    name: "SwiftWhisper",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "SwiftWhisper", targets: ["SwiftWhisper"])
    ],
    dependencies: [
        .package(url: "https://github.com/ggerganov/whisper.cpp", .branchItem("master")),
    ],
    targets: [
        .target(name: "SwiftWhisper", dependencies: [.product(name: "whisper", package: "whisper.cpp")]),
        .testTarget(name: "WhisperTests", dependencies: [.target(name: "SwiftWhisper")], resources: [.copy("TestResources/")])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)

