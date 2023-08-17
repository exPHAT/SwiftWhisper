import Foundation
import XCTest
@testable import SwiftWhisper

class LoadModelTests: ResourceDependentTestCase, ModelFileTestCase {
    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testLoadModelFromFile() async {
        let modelURL = await tinyModelURL!
        let _ = Whisper(fromFileURL: modelURL)
    }

    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testLoadModelFromData() async throws {
        let modelURL = await tinyModelURL!
        let modelData = try Data(contentsOf: modelURL)
        let _ = Whisper(fromData: modelData)
    }
}
