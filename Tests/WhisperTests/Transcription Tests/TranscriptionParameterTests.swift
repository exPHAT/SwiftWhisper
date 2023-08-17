import XCTest
@testable import SwiftWhisper

class TranscriptionParamterTests: ResourceDependentTestCase, ModelFileTestCase, AudioFileTestCase {
    let timeout: TimeInterval = 60

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testParametersMaxLen() async throws {
        let params = WhisperParams()
        params.language = .english
        params.max_len = 1
        params.token_timestamps = true

        let modelURL = await tinyModelURL!
        let whisper = Whisper(fromFileURL: modelURL, withParams: params)
        let jfk = jfkAudioFrames!

        let segments = try await whisper.transcribe(audioFrames: jfk)

        // The JFK audio contains 23 non-empty segments
        XCTAssert(segments.filter { !$0.text.isEmpty }.count == 23)
    }
}
