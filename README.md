# SwiftWhisper

> The easiest way to use Whisper in Swift

Easily add transcription to your app or package. Powered by [whisper.cpp](https://github.com/ggerganov/whisper.cpp).

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FexPHAT%2FSwiftWhisper%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/exPHAT/SwiftWhisper)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FexPHAT%2FSwiftWhisper%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/exPHAT/SwiftWhisper)

## Install


#### Swift Package Manager

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

#### Xcode

Add `https://github.com/exPHAT/SwiftWhisper.git` in the ["Swift Package Manager" tab.](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## Usage

[API Documentation.](https://swiftpackageindex.com/exPHAT/SwiftWhisper/1.0.1/documentation/)

```swift
import SwiftWhisper

let whisper = Whisper(fromFileURL: /* Model file URL */)
let segments = try await whisper.transcribe(audioFrames: /* 16kHz PCM audio frames */)

print("Transcribed audio:", segments.map(\.text).joined())
```

#### Delegate methods

You can subscribe to segments, transcription progress, and errors by implementing `WhisperDelegate` and setting `whisper.delegate = ...`

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

## Misc

### Downloading Models :inbox_tray:

You can find the pre-trained models [here](https://huggingface.co/ggerganov/whisper.cpp) for download.

### CoreML Support :brain:

To use CoreML, you'll need to include a CoreML model file with the suffix `-encoder.mlmodelc` under the same name as the whisper model (Example: `tiny.bin` would also sit beside a `tiny-encoder.mlmodelc` file). In addition to the additonal model file, you will also need to use the `Whisper(fromFileURL:)` initializer. You can verify CoreML is active by checking the console output during transcription.

### Converting audio to 16kHz PCM :wrench:

The easiest way to get audio frames into SwiftWhisper is to use [AudioKit](https://github.com/AudioKit/AudioKit). The following example takes an input audio file, converts and resamples it, and returns an array of 16kHz PCM floats.

```swift
import AudioKit

func convertAudioFileToPCMArray(fileURL: URL, completionHandler: @escaping (Result<[Float], Error>) -> Void) {
    var options = FormatConverter.Options()
    options.format = .wav
    options.sampleRate = 16000
    options.bitDepth = 16
    options.channels = 1
    options.isInterleaved = false

    let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
    let converter = FormatConverter(inputURL: fileURL, outputURL: tempURL, options: options)
    converter.start { error in
        if let error {
            completionHandler(.failure(error))
            return
        }

        let data = try! Data(contentsOf: tempURL) // Handle error here

        let floats = stride(from: 44, to: data.count, by: 2).map {
            return data[$0..<$0 + 2].withUnsafeBytes {
                let short = Int16(littleEndian: $0.load(as: Int16.self))
                return max(-1.0, min(Float(short) / 32767.0, 1.0))
            }
        }

        try? FileManager.default.removeItem(at: tempURL)

        completionHandler(.success(floats))
    }
}
```

### Development speed boost :rocket:

You may find the performance of the transcription slow when compiling your app for the `Debug` build configuration. This is because the compiler doesn't fully optimize SwiftWhisper unless the build configuration is set to `Release`.

You can get around this by installing a version of SwiftWhisper that uses `.unsafeFlags(["-O3"])` to force maximum optimization. The easiest way to do this is to use the latest commit on the [`fast`](https://github.com/exPHAT/SwiftWhisper/tree/fast) branch. Alternatively, you can configure your scheme to build in the `Release` configuration.

```swift
  ...
  dependencies: [
    // Using latest commit hash for `fast` branch:
    .package(url: "https://github.com/exPHAT/SwiftWhisper.git", revision: "deb1cb6a27256c7b01f5d3d2e7dc1dcc330b5d01"),
  ],
  ...
```
