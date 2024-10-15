import Foundation
import SwiftUI

extension TD {
    @MainActor
    struct Group: Identifiable, Hashable {
        let id: Category
        var tasks: [Task]
        var isExpanded: Bool

        var isEmpty: Bool {
            return tasks.isEmpty
        }

        var displayName: LocalizedStringKey {
            return id.displayName
        }
    }
}
