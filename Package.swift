// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftWhisper",
    products: [
        .library(name: "SwiftWhisper", targets: ["SwiftWhisper"])
    ],
    targets: [
        .target(name: "SwiftWhisper", dependencies: [.target(name: "whisper_cpp")]),
        .target(name: "whisper_cpp", cSettings: [
            .define("GGML_USE_ACCELERATE", .when(platforms: [.macOS, .macCatalyst, .iOS])),
            .define("WHISPER_USE_COREML", .when(platforms: [.macOS, .macCatalyst, .iOS])),
            .define("WHISPER_COREML_ALLOW_FALLBACK", .when(platforms: [.macOS, .macCatalyst, .iOS])),
            .unsafeFlags(["-O3"])
        ]),
        .testTarget(name: "WhisperTests", dependencies: [.target(name: "SwiftWhisper")], resources: [.copy("TestResources/")])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
