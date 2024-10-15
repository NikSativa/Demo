import Foundation

enum AppConstant {
    static let isRunningForPreviews: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    static let isRunningForTests: Bool = ProcessInfo.processInfo.environment["XCTestSessionIdentifier"]?.isEmpty == false

    static let isSimulator: Bool = {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }()
}
