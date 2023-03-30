import XCTest

class ResourceDependentTestCase: XCTestCase {

    // Location of the TestResources folder
    lazy var resourceURL: URL? = {
        var url = URL(fileURLWithPath: #file)

        while true {
            url = url.deletingLastPathComponent()

            if let files = try? FileManager.default.contentsOfDirectory(atPath: url.path) {
                if files.contains("TestResources") {
                    return url.appendingPathComponent("TestResources")
                }
            }

            guard url.path.count > 1 else { break }
        }

        return nil
    }()
}
