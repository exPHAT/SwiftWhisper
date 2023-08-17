import XCTest
@testable import SwiftWhisper

class TranscriptionTests: ResourceDependentTestCase, ModelFileTestCase, AudioFileTestCase {
    let timeout: TimeInterval = 60

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    fileprivate var whisperTinyModel: Whisper {
        get async {
            let modelURL = await tinyModelURL!
            let whisper = Whisper(fromFileURL: modelURL)

            return whisper
        }
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTrascribeCompletionHandler() async {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        let successExpectation = expectation(description: "Transcription will call the completion handler with success")

        whisper.transcribe(audioFrames: jfk) { result in
            let segments = try! result.get()
            XCTAssert(segments.count > 0)

            let text = segments.map(\.text).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            XCTAssert(text == "and so my fellow americans ask not what your country can do for you ask what you can do for your country.")

            successExpectation.fulfill()
        }

        wait(for: [successExpectation], timeout: timeout)
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscribeExclusivity() async {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        let successExpectation = expectation(description: "Transcription will call the original completion handler with success")
        let failureExpectation = expectation(description: "Transcription will call the second completion handler with failure")

        whisper.transcribe(audioFrames: jfk) { result in
            if case .success(let segments) = result {
                XCTAssert(segments.count > 0)
            } else {
                XCTFail("First callback should succeed")
            }

            successExpectation.fulfill()
        }

        whisper.transcribe(audioFrames: jfk) { result in
            if case .failure(let error) = result {
                XCTAssert((error as? WhisperError) == WhisperError.instanceBusy)
            } else {
                XCTFail("Second callback should fail")
            }

            failureExpectation.fulfill()
        }

        wait(for: [successExpectation, failureExpectation], timeout: timeout)
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscribeInvalidFramesError() async {
        let whisper = await whisperTinyModel

        let failureExpectation = expectation(description: "Transcription will call the completion handler with failure")

        whisper.transcribe(audioFrames: []) { result in
            if case .failure(let error) = result {
                XCTAssert((error as? WhisperError) == WhisperError.invalidFrames)
            } else {
                XCTFail("Second callback should fail")
            }

            failureExpectation.fulfill()
        }

        wait(for: [failureExpectation], timeout: 5)
    }

    // Used in testTranscribeDelegate()
    var delegateNewSegmentExpectation: XCTestExpectation?
    var delegateProgessExpectation: XCTestExpectation?
    var delegateCompletionExpectation: XCTestExpectation?
}

extension TranscriptionTests: WhisperDelegate {
    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscribeDelegate() async throws {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        self.delegateNewSegmentExpectation = .init(description: "Transcriber should call whisper(_:didProcessNewSegments:atIndex:)")
        self.delegateProgessExpectation = .init(description: "Transcriber should call whisper(_:didUpdateProgress:)")
        self.delegateCompletionExpectation = .init(description: "Transcriber should call whisper(_:didCompleteWithSegments)")

        whisper.delegate = self

        let segments = try await whisper.transcribe(audioFrames: jfk)

        XCTAssert(segments.count > 0)

        wait(for: [
            try XCTUnwrap(delegateNewSegmentExpectation),
            try XCTUnwrap(delegateProgessExpectation),
            try XCTUnwrap(delegateCompletionExpectation)
        ], timeout: timeout)

        self.delegateNewSegmentExpectation = nil
        self.delegateProgessExpectation = nil
        self.delegateCompletionExpectation = nil
    }

    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int) {
        delegateNewSegmentExpectation?.fulfill()
    }

    func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double) {
        delegateProgessExpectation?.fulfill()
    }

    func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment]) {
        delegateCompletionExpectation?.fulfill()
    }
}
