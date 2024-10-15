import Foundation
import SwiftUI

enum AppSymbol: String, CaseIterable {
    case chevronRight = "chevron.right"
    case chevronDown = "chevron.down"
    case sorting = "arrow.up.arrow.down"
    case addNewTask = "plus.circle"
    case deleteTask = "trash"

    @MainActor
    func imageView(_ color: Color = .Td.defaultFont) -> some View {
        Image(systemName: rawValue)
            .resizable()
            .scaledToFit()
            .foregroundColor(color)
    }
}
