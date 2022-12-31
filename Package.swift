// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "whisper.spm",
    products: [
        .library(
            name: "whisper",
            targets: ["whisper"])
    ],
    targets: [
        .target(name: "whisper", dependencies:[], cSettings: [.unsafeFlags(["-O3", "-DGGML_USE_ACCELERATE=1"])]),
        .target(name: "test-objc", dependencies:["whisper"]),
        .target(name: "test-swift", dependencies:["whisper"])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
