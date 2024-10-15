import Foundation

extension TD {
    struct Filter: Hashable, Codable {
        var showExpired: Bool
        var groupedByCategory: Bool

        static let `default`: Filter = .init(showExpired: false, groupedByCategory: true)
    }
}
