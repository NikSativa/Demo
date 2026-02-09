import DIKit
import Foundation

final class ViewModelsAssembly: Assembly {
    func assemble(with registrator: Registrator) {
        registrator.register(MainView.ViewModel.self, options: .transient) { resolver in
            return .init(dataBase: resolver.resolve())
        }

        registrator.register(TaskView.ViewModel.self, options: .transient) { resolver, args in
            return .init(dataBase: resolver.resolve(),
                         alertPresenter: resolver.resolve(),
                         task: args.first(),
                         isEditing: args.first())
        }
    }
}
