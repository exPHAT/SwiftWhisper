// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Whisper",
    platforms: [.macOS(.v12), .iOS(.v13)],
    products: [
        .library(name: "Whisper",
                 targets: ["Whisper"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.51.0")
    ],
    targets: [
        .target(name: "Whisper",
                dependencies: [.target(name: "whisper_cpp")],
                plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),

        .target(name: "whisper_cpp",
                cSettings: [.unsafeFlags(["-O3","-DGGML_USE_ACCELERATE=1", "-Wno-everything"])]),
        .testTarget(name: "WhisperTests", dependencies: [.target(name: "Whisper")], resources: [.copy("TestResources/")])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
