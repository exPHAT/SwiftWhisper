
import XCTest
@testable import SwiftWhisper

class TranscriptionCancellationTests: ResourceDependentTestCase, ModelFileTestCase, AudioFileTestCase {
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
    func testTranscribeCancellation() async {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        let failureExpectation = expectation(description: "Transcription will call the completion handler with error")
        let cancelExpectation = expectation(description: "Cancel will be called after transcription has started")

        whisper.transcribe(audioFrames: jfk) { result in
            if case .failure(let error) = result {
                XCTAssert((error as? WhisperError) == WhisperError.cancelled)
            } else {
                XCTFail("Callback should not succeed")
            }

            failureExpectation.fulfill()
        }

        XCTAssertNoThrow(
            try whisper.cancel {
                cancelExpectation.fulfill()
            }
        )

        wait(for: [cancelExpectation, failureExpectation], timeout: timeout)
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscribeCancellationRestart() async {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        let failureExpectation = expectation(description: "Transcription will call the completion handler with error")
        let cancelExpectation = expectation(description: "Cancel will be called after transcription has started")
        let restartExpectation = expectation(description: "Transcription will restart and complete after cancellation")

        whisper.transcribe(audioFrames: jfk) { result in
            if case .failure(let error) = result {
                XCTAssert((error as? WhisperError) == WhisperError.cancelled)
            } else {
                XCTFail("Callback should not succeed")
            }

            failureExpectation.fulfill()
        }

        XCTAssertNoThrow(
            try whisper.cancel {
                cancelExpectation.fulfill()

                whisper.transcribe(audioFrames: jfk) { result in
                    if case .success(let segments) = result {
                        XCTAssert(segments.count > 0)
                    } else {
                        XCTFail("Restarted transcription should succeed")
                    }

                    restartExpectation.fulfill()
                }
            }
        )

        wait(for: [cancelExpectation, failureExpectation, restartExpectation], timeout: timeout)
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscribeDoubleCancellation() async {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        let failureExpectation = expectation(description: "Transcription will call the completion handler with error")
        let cancelExpectation = expectation(description: "Cancel will be called after transcription has started")

        whisper.transcribe(audioFrames: jfk) { result in
            if case .failure(let error) = result {
                XCTAssert((error as? WhisperError) == WhisperError.cancelled)
            } else {
                XCTFail("Callback should not succeed")
            }

            failureExpectation.fulfill()
        }

        XCTAssertNoThrow(
            try whisper.cancel {
                cancelExpectation.fulfill()
            }
        )

        XCTAssertThrowsError(
            try whisper.cancel {
                XCTFail("Should not call second cancellation")
            }
        )

        wait(for: [cancelExpectation, failureExpectation], timeout: timeout)
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscribePrematureCancellation() async {
        let whisper = await whisperTinyModel

        do {
            try whisper.cancel {
                XCTFail("Should not call cancellation when transcription never started")
            }

            XCTFail("Should error instead of continuing")
        } catch {
            XCTAssert((error as? WhisperError) == .cancellationError(.notInProgress))
        }
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscriptionAsyncCancel() async {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        let failureExpectation = expectation(description: "Transcription will call the completion handler with error")
        let cancelledExpectation = expectation(description: "Transcription will asyncronously reach past cancel method call")

        whisper.transcribe(audioFrames: jfk) { result in
            if case .failure(let error) = result {
                XCTAssert((error as? WhisperError) == WhisperError.cancelled)
            } else {
                XCTFail("Callback should not succeed")
            }

            failureExpectation.fulfill()
        }

        do {
            try await whisper.cancel()

            cancelledExpectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }

        // Should be fine because function is async, but just to be safe
        wait(for: [failureExpectation, cancelledExpectation], timeout: timeout)
    }


    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testTranscriptionAsyncCancelTwice() async {
        let whisper = await whisperTinyModel
        let jfk = jfkAudioFrames!

        let failureExpectation = expectation(description: "Transcription will call the completion handler with error")
        let cancelledExpectation = expectation(description: "Execution will asyncronously reach past cancel method call")
        let cancellationFailureExpectation = expectation(description: "Second cancel method call will cause an error")

        whisper.transcribe(audioFrames: jfk) { result in
            if case .failure(let error) = result {
                XCTAssert((error as? WhisperError) == WhisperError.cancelled)
            } else {
                XCTFail("Callback should not succeed")
            }

            failureExpectation.fulfill()
        }

        do {
            try await whisper.cancel()

            cancelledExpectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }

        do {
            try await whisper.cancel()

            XCTFail("Should error instead of continuing")
        } catch {
            cancellationFailureExpectation.fulfill()

            XCTAssert((error as? WhisperError) == .cancellationError(.notInProgress))
        }

        // Should be fine because function is async, but just to be safe
        wait(for: [failureExpectation, cancelledExpectation, cancellationFailureExpectation], timeout: timeout)
    }
}
