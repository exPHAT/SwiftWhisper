import Foundation
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol ModelFileTestCase: ResourceDependentTestCase {
    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    var tinyModelURL: URL? { get async }
}

extension ModelFileTestCase {
    @available(iOS 13, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    var tinyModelURL: URL? {
        get async {
            let hostedModelURL = URL(string: "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin")!

            guard let path = resourceURL?.appendingPathComponent("tiny.bin") else { return nil }

            if FileManager.default.fileExists(atPath: path.path) {
                return path
            }

            do {
                let url = try await withCheckedThrowingContinuation { (cont: CheckedContinuation<URL, Error>) -> Void in
                    let urlRequest = URLRequest(url: hostedModelURL)

                    URLSession.shared.downloadTask(with: urlRequest) { url, _, error in
                        if let error {
                            cont.resume(throwing: error)
                        }

                        cont.resume(returning: url!)
                    }.resume()
                }

                try FileManager.default.copyItem(at: url, to: path)
            } catch {
                return nil
            }

            return path
        }
    }
}
