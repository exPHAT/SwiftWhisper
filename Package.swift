// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Whisper",
    products: [
        .library(name: "Whisper",
                 targets: ["Whisper"])
    ],
    targets: [
        .target(name: "Whisper", dependencies: [.target(name: "whisper_cpp")]),
        .target(name: "whisper_cpp", cSettings: [.unsafeFlags(["-O3","-DGGML_USE_ACCELERATE=1"])]),
        .testTarget(name: "WhisperTests", dependencies: [.target(name: "Whisper")])
//        .target(name: "whisper_cpp",
//                path: "Sources/whisper_cpp",
//                sources: ["whisper.cpp", "ggml.c"],
//                publicHeadersPath: "./test",
//                cSettings: [.unsafeFlags(["-O3", "-DGGML_USE_ACCELERATE=1"])])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
