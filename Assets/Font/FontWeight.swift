import Foundation
import SwiftUI

/// erasing unused cases
enum FontWeight {
    case regular
    case bold
    case medium

    static var `default`: Self {
        return .regular
    }
}
