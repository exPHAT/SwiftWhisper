// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "SwiftWhisper",
    products: [
        .library(name: "SwiftWhisper", targets: ["SwiftWhisper"])
    ],
    targets: [
        .target(name: "SwiftWhisper", dependencies: [.target(name: "whisper_cpp")]),
        .target(name: "whisper_cpp",
                cSettings: [.unsafeFlags(["-O3","-DGGML_USE_ACCELERATE=1", "-Wno-everything"])]),
        .testTarget(name: "WhisperTests", dependencies: [.target(name: "SwiftWhisper")], resources: [.copy("TestResources/")])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
