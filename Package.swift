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
        .target(name: "whisper_cpp", dependencies:[], cSettings: [.define("GGML_USE_ACCELERATE")]),
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
