import DIKit
import Foundation
import StorageKit

final class AppAssembly: Assembly {
    func assemble(with registrator: Registrator) {
        registrator.register(DBManager.self, options: .container) { resolver in
            return Impl.DBManager(storage: resolver.resolve())
        }

        registrator.register(AnyStorage<[TD.Task]?>.self, options: .container) { _ in
            return zip(storages: [
                InMemoryStorage(),
                FileStorage<[TD.Task]?>(fileName: "Tasks.json").toAny()
            ]).toAny()
        }

        registrator.isolatedMain.register(Impl.AlertPresenter.self, options: .container) {
            return .init()
        }
        .implements(AlertPresenter.self)
    }
}
