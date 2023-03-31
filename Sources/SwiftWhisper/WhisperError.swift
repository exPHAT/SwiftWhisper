import Foundation

public enum WhisperError: Error, Equatable {
    public enum WhisperCancellationError: Error, Equatable {
        case pendingCancellation
        case notInProgress
    }

    case invalidFrames
    case instanceBusy
    case cancelled
    case cancellationError(WhisperCancellationError)
}
