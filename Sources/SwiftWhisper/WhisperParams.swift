import Foundation
import whisper_cpp

// swiftlint:disable identifier_name
@dynamicMemberLookup
public class WhisperParams {
    public static let `default` = WhisperParams(strategy: .greedy)

    internal var whisperParams: whisper_full_params
    internal var _language: UnsafeMutablePointer<CChar>?

    public init(strategy: WhisperSamplingStrategy = .greedy) {
        self.whisperParams = whisper_full_default_params(whisper_sampling_strategy(rawValue: strategy.rawValue))
        self.language = .auto
    }

    deinit {
        if let _language = _language {
            free(_language)
        }
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<whisper_full_params, T>) -> T {
        get { whisperParams[keyPath: keyPath] }
        set { whisperParams[keyPath: keyPath] = newValue }
    }

    public var language: WhisperLanguage {
        get { .init(rawValue: String(Substring(cString: whisperParams.language)))! }
        set {
            guard let pointer = strdup(newValue.rawValue) else { return }

            if let _language = _language {
                free(_language) // Free previous reference since we're creating a new one
            }

            self._language = pointer
            whisperParams.language = UnsafePointer(pointer)
        }
    }
}
// swiftlint:enable identifier_name
