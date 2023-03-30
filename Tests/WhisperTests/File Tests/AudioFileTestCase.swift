import XCTest

protocol AudioFileTestCase: ResourceDependentTestCase {
    var jfkURL: URL? { get }
    var jfkAudioFrames: [Float]? { get }
}

extension AudioFileTestCase {
    var jfkURL: URL? { resourceURL?.appendingPathComponent("jfk.wav") }
    var jfkAudioFrames: [Float]? {
        guard let jfkURL else { return nil }

        let data = try! Data(contentsOf: jfkURL)
        return stride(from: 44, to: data.count, by: 2).map {
            return data[$0..<$0 + 2].withUnsafeBytes {
                let short = Int16(littleEndian: $0.load(as: Int16.self))
                return max(-1.0, min(Float(short) / 32767.0, 1.0))
            }
        }
    }
}
