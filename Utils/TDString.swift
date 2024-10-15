import SwiftUI

enum TDString {
    case verbatim(String)
    case localized(LocalizedStringKey)
}

extension TDString {
    var textView: Text {
        switch self {
        case .verbatim(let string):
            Text(string)
        case .localized(let localizedStringKey):
            Text(localizedStringKey)
        }
    }
}
