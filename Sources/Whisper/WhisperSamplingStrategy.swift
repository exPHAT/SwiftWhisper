import Foundation

public enum WhisperSamplingStrategy: UInt32 {
    case greedy = 0
    case beamSearch
}
