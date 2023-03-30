import XCTest
@testable import Whisper

class TranscriptionTests: ResourceDependentTestCase, ModelFileTestCase, AudioFileTestCase {
    func testTrascribeCompletionHandler() async {
        let modelURL = await tinyModelURL!
        let jfk = jfkAudioFrames!

        let whisper = Whisper(fromFileURL: modelURL)

        let expectation = expectation(description: "Transcription will call the delegate method")

        whisper.transcribe(audioFrames: jfk) { result in
            let segments = try! result.get()
            XCTAssert(segments.count > 0)

            let text = segments.map(\.text).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            XCTAssert(text == "and so my fellow americans ask not what your country can do for you ask what you can do for your country.")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }


    var delegateNewSegmentExpectation: XCTestExpectation?
    var delegateProgessExpectation: XCTestExpectation?
    var delegateCompletionExpectation: XCTestExpectation?

    func testTranscribeDelegate() async throws {
        let modelURL = await tinyModelURL!
        let jfk = jfkAudioFrames!

        let whisper = Whisper(fromFileURL: modelURL)

        self.delegateNewSegmentExpectation = .init(description: "Transcriber should call the new segment delegate method")
        self.delegateProgessExpectation = .init(description: "Transcriber should call the progress delegate method")
        self.delegateCompletionExpectation = .init(description: "Transcriber should call the completion delegate method")

        whisper.delegate = self

        let segments = try await whisper.transcribe(audioFrames: jfk)

        XCTAssert(segments.count > 0)

        wait(for: [
            try XCTUnwrap(delegateNewSegmentExpectation),
            try XCTUnwrap(delegateProgessExpectation),
            try XCTUnwrap(delegateCompletionExpectation)
        ], timeout: 5)
    }
}

extension TranscriptionTests: WhisperDelegate {
    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int) {
        delegateNewSegmentExpectation?.fulfill()
    }

    func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Float) {
        print("PROGRESS", progress)
        delegateProgessExpectation?.fulfill()
    }

    func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment]) {
        delegateCompletionExpectation?.fulfill()
    }
}
