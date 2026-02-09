import DIKit
import Foundation

final class AppContainer {
    private let container: Container

    init() {
        self.container = Container(assemblies: [
            AppAssembly(),
            ViewModelsAssembly()
        ])
    }
}

// MARK: - Resolver

extension AppContainer: Resolver {
    func optionalResolve<T>(type: T.Type, named: String?, with arguments: Arguments) -> T? {
        return container.optionalResolve(type, named: named, with: arguments)
    }
}
