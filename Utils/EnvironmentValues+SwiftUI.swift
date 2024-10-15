import Foundation
import SwiftUI

private struct IsPreviewKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct IsSimulatorKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    /// A Boolean value that indicates whether the view is represented in a SwiftUI preview mode.
    var isRunningForPreviews: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }

    /// A Boolean value that indicates whether the view is represented in a simulator.
    var isSimulator: Bool {
        get { self[IsSimulatorKey.self] }
        set { self[IsSimulatorKey.self] = newValue }
    }
}
