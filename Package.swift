// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Whisper",
    products: [
        .library(
            name: "Whisper",
            targets: ["Whisper"])
    ],
    targets: [
        .target(name: "Whisper", dependencies: [.target(name: "whisper_cpp")]),
        .target(name: "whisper_cpp", dependencies:[], cSettings: [.unsafeFlags(["-O3", "-DGGML_USE_ACCELERATE=1"])]),
//        .target(name: "test-objc", dependencies: [.target(name: "Whisper")]),
//        .target(name: "test-swift", dependencies: [.target(name: "Whisper")])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
