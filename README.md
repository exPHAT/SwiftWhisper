# SwiftWhisper

> The easiest way to use Whisper in Swift

Easily add transcription to your app or package. Powered by [whisper.cpp](https://github.com/ggerganov/whisper.cpp).

## Install

#### Xcode

Add `https://github.com/exPHAT/SwiftWhisper.git` in the ["Swift Package Manager" tab.](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

#### Swift Package

Add SwiftWhisper as a dependency in your `Package.swift` file:

```swift
let package = Package(
  ...
  dependencies: [
    // Add the package to your dependencies
    .package(url: "https://github.com/exPHAT/SwiftWhisper.git", branch: "master"),
  ],
  ...
  targets: [
    // Add SwiftWhisper as a dependency on any target you want to use it in
    .target(name: "MyTarget",
            dependencies: [.byName(name: "SwiftWhisper")])
  ]
  ...
)
```

## Usage

[API Documentation.](https://swiftpackageindex.com/exPHAT/SwiftWhisper/v1.0.0/documentation/)

**All audio must be 16kHz audio frames**

```swift
import SwiftWhisper

let whisper = Whisper(fromFileURL: /* Model file URL */)
let segments = try await whisper.transcribe(audioFrames: /* 16kHz PCM audio frames */)

print("Transcribed audio:", segments.map(\.text).joined())
```

#### Delegate methods

```swift
protocol WhisperDelegate {
  // Progress updates as a percentage from 0-1
  func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double)

  // Any time a new segments of text have been transcribed
  func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int)
  
  // Finished transcribing, includes all transcribed segments of text
  func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment])

  // Error with transcription
  func whisper(_ aWhisper: Whisper, didErrorWith error: Error)
}
```

