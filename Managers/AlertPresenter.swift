import Foundation
import SwiftUI

protocol AlertPresenter {
    func show(_ error: Error)
}

// MARK: - Impl.AlertPresenter

extension Impl {
    @Observable
    final class AlertPresenter: ObservableObject {
        var isPresented: Bool = false
        var error: TD.Error?
    }
}

// MARK: - Impl.AlertPresenter + AlertPresenter

extension Impl.AlertPresenter: AlertPresenter {
    func show(_ error: Error) {
        if let error = error as? TD.Error {
            self.error = error
            isPresented = true
        } else {
            assertionFailure("Unexpected error: \(error)")
        }
    }
}

struct AlertPresenterViewModifier: ViewModifier {
    @ObservedObject
    var alertPresenter: Impl.AlertPresenter

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $alertPresenter.isPresented,
                   error: alertPresenter.error,
                   actions: {
                       Button(action: {
                           alertPresenter.error = nil
                           alertPresenter.isPresented = false
                       }) {
                           Text("alert.button.ok")
                       }
                   })
            .environment(alertPresenter)
    }
}
