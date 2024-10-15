import Foundation
import SwiftUI

extension TD {
    enum Priority: Hashable, CaseIterable, Comparable, Codable {
        case low
        case medium
        case high

        static let `default`: Self = .medium

        var displayName: LocalizedStringKey {
            switch self {
            case .low:
                return "task.priority.low"
            case .medium:
                return "task.priority.medium"
            case .high:
                return "task.priority.high"
            }
        }
    }
}
