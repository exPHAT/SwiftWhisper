import Foundation

public protocol WhisperDelegate: AnyObject {
    func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double)
    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int)
    func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment])
    func whisper(_ aWhisper: Whisper, didErrorWith error: Error)
}

public extension WhisperDelegate {
    func whisper(_ aWhisper: Whisper, didUpdateProgress progress: Double) {
        //
    }

    func whisper(_ aWhisper: Whisper, didProcessNewSegments segments: [Segment], atIndex index: Int) {
        //
    }

    func whisper(_ aWhisper: Whisper, didCompleteWithSegments segments: [Segment]) {
        //
    }

    func whisper(_ aWhisper: Whisper, didErrorWith error: Error) {
        //
    }
}
