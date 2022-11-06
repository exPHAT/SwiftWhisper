// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "whisper.cpp",
    products: [
        .library(
            name: "whisper.cpp",
            targets: ["whisper.cpp"]),
    ],
    targets: [
        .target(name: "whisper.cpp", dependencies:[], exclude: []),
        .target(name: "test-objc", dependencies:["whisper.cpp"]),
        .target(name: "test-swift", dependencies:["whisper.cpp"])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
