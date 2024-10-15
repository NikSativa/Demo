import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func devBackground(_ color: Color = .green) -> some View {
        #if DEBUG
        background(color.opacity(0.5))
        #else
        self
        #endif
    }

    @ViewBuilder
    func devStroke(_ color: Color = .red) -> some View {
        #if DEBUG
        overlay {
            Rectangle().stroke(color, lineWidth: 1)
        }
        #else
        self
        #endif
    }
}
