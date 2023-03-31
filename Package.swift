// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Whisper",
    products: [
        .library(name: "Whisper", targets: ["Whisper"])
    ],
    targets: [
        .target(name: "Whisper", dependencies: [.target(name: "whisper_cpp")]),
        .target(name: "whisper_cpp",
                cSettings: [.unsafeFlags(["-O3","-DGGML_USE_ACCELERATE=1", "-Wno-everything"])]),
        .testTarget(name: "WhisperTests", dependencies: [.target(name: "Whisper")], resources: [.copy("TestResources/")])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
