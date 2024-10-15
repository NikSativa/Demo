import Foundation
import SwiftUI

extension Text {
    func textStyle(with color: Color = .Td.defaultFont,
                   size: FontSize = .default,
                   weight: FontWeight = .default) -> Self {
        foregroundColor(color)
            .font(.system(size: size.value, weight: weight.systemWeight))
    }
}

private extension FontWeight {
    var systemWeight: Font.Weight {
        switch self {
        case .bold:
            return .bold
        case .medium:
            return .medium
        case .regular:
            return .regular
        }
    }
}
