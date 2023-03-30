import Foundation
import XCTest
@testable import Whisper

class LoadModelTests: ResourceDependentTestCase, ModelFileTestCase {
    func testLoadModelFromFile() async {
        let modelURL = await tinyModelURL!
        let _ = Whisper(fromFileURL: modelURL)
    }

    func testLoadModelFromData() async throws {
        let modelURL = await tinyModelURL!
        let modelData = try Data(contentsOf: modelURL)
        let _ = Whisper(fromData: modelData)
    }
}
