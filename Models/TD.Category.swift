import Foundation
import SwiftUI

// MARK: - TD.Category

extension TD {
    struct Category: Hashable, Identifiable {
        typealias ID = String

        let id: ID

        init(id: String) {
            self.id = id.lowercased()
        }

        static let `default`: Self = .personal
        static let personal: Self = .init(id: "personal")
        static let work: Self = .init(id: "work")
        static let home: Self = .init(id: "home")

        var displayName: LocalizedStringKey {
            switch self {
            case .personal:
                return "category.personal.title"
            case .work:
                return "category.work.title"
            case .home:
                return "category.home.title"
            default:
                assert(isCustom, "Should be localized \(id)")
                return LocalizedStringKey(id)
            }
        }

        var isCustom: Bool {
            return !Self.allCases.contains(self)
        }
    }
}

// MARK: - TD.Category + ExpressibleByStringLiteral

extension TD.Category: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(id: value)
    }
}

// MARK: - CaseIterable

extension TD.Category {
    static var allCases: [TD.Category] {
        return [.home, .personal, .work]
    }
}

// MARK: - TD.Category + Comparable

extension TD.Category: Comparable {
    static func <(lhs: TD.Category, rhs: TD.Category) -> Bool {
        let unknownLhs = !allCases.contains(lhs)
        let unknownRhs = !allCases.contains(rhs)

        if unknownLhs, unknownRhs {
            return lhs.id < rhs.id
        } else if unknownLhs {
            // always in the end of list
            return false
        } else if unknownRhs {
            // always in the end of list
            return true
        }
        return lhs.id < rhs.id
    }
}

// MARK: - TD.Category + Codable

extension TD.Category: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.id = try container.decode(String.self).lowercased()
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(id)
    }
}
