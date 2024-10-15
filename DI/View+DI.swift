import DIKit
import Foundation
import SwiftUI

extension View {
    /// **ONLY FOR PREVIEW**
    /// Injects the environment object container into the view and resolve some dependencies if needed.
    func previewEnvironment(shouldMakeFakeDB: Bool = true,
                            isComponentView: Bool = false,
                            _ postSettings: (_ resolver: Resolver) -> Void = { _ in }) -> some View {
        assert(AppConstant.isRunningForPreviews, "This method should be used only for previews")

        let container = AppContainer()

        if shouldMakeFakeDB {
            let db = container.resolve(DBManager.self)
            db.mockify()
        }

        defer {
            postSettings(container)
        }

        return preview(isComponent: isComponentView)
            .environmentObject(container.toObservable())
            .commonEnvironment(container)
    }

    func realEnvironment(_ container: AppContainer) -> some View {
        return environmentObject(container.toObservable())
            .commonEnvironment(container)
    }

    private func commonEnvironment(_ resolver: Resolver) -> some View {
        return environment(\.isRunningForPreviews, AppConstant.isRunningForPreviews)
            .environment(\.isSimulator, AppConstant.isSimulator)
            .modifier(AlertPresenterViewModifier(alertPresenter: resolver.resolve()))
    }
}

private extension View {
    @ViewBuilder
    func preview(isComponent: Bool) -> some View {
        if isComponent {
            self
        } else {
            NavigationView {
                self
            }
        }
    }
}
