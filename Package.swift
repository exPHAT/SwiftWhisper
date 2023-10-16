// swift-tools-version:5.5
import PackageDescription

var exclude: [String] = []

#if os(Linux)
// Linux doesn't support CoreML, and will attempt to import the coreml source directory
exclude.append("coreml")
#endif

let package = Package(
    name: "SwiftWhisper",
    products: [
        .library(name: "SwiftWhisper", targets: ["SwiftWhisper"])
    ],
    targets: [
        .target(
            name: "SwiftWhisper",
            dependencies: ["whisper_cpp", "whisper_cpp_metal"]
        ),
        .target(
            name: "whisper_cpp_metal",
            path: "Sources/whisper_metal",
            sources: ["ggml-metal.m"],
            resources: [.process("../Resources/ggml-metal.metal")],
            publicHeadersPath: "include",
            cSettings: [
                .unsafeFlags(["-fno-objc-arc"])
            ]
        ),
        .target(
            name: "whisper_cpp",
            dependencies: [.target(name: "whisper_cpp_metal")],
            path: "Sources/whisper_cpp",
            sources: [
                "ggml.c",
                "ggml-alloc.c",
                "coreml/whisper-encoder-impl.m",
                "coreml/whisper-encoder.mm",
                "whisper.cpp",
            ],
            publicHeadersPath: "include",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32"]),
                .define("GGML_USE_ACCELERATE", .when(platforms: [.macOS, .macCatalyst, .iOS])),
                .define("WHISPER_USE_COREML", .when(platforms: [.macOS, .macCatalyst, .iOS])),
                .define("WHISPER_COREML_ALLOW_FALLBACK", .when(platforms: [.macOS, .macCatalyst, .iOS])),
                .define("GGML_USE_METAL", .when(platforms: [.macOS, .macCatalyst, .iOS]))
            ],
            linkerSettings: [
                .linkedFramework("Accelerate"),
            ]
        ),
        .testTarget(
            name: "WhisperTests",
            dependencies: ["SwiftWhisper"],
            resources: [.copy("TestResources/")]
        )
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)

