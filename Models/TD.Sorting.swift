import Foundation
import SwiftUI

extension TD {
    enum Sorting: String, Hashable, CaseIterable, Codable {
        case byPriority
        case byDueDate

        static let `default`: Self = .byDueDate

        var displayName: LocalizedStringKey {
            switch self {
            case .byPriority:
                return "todoSorting.byPriority"
            case .byDueDate:
                return "todoSorting.byDueDate"
            }
        }
    }
}
