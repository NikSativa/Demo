import Combine
import Foundation
import StorageKit
import SwiftUI

// MARK: - MainView.ViewModel

extension MainView {
    @MainActor
    final class ViewModel: ViewModeling {
        private var cancellables: Set<AnyCancellable> = []
        private let dataBase: DBManager

        @Published var groups: [TD.Group] = []
        @Published var tasks: [TD.Task] = []

        @Defaults(key: "app.filter")
        var sorting: TD.Sorting = .default

        @Defaults(key: "app.sorting")
        var filter: TD.Filter = .default

        init(dataBase: DBManager,
             sorting: Defaults<TD.Sorting>? = nil,
             filter: Defaults<TD.Filter>? = nil) {
            self.dataBase = dataBase

            if let filter {
                self._filter = filter
            }

            if let sorting {
                self._sorting = sorting
            }

            Publishers.CombineLatest3($sorting, $filter, dataBase.tasksPublisher)
                .removeDuplicates(by: ==)
                .sink { [unowned self] sorting, filter, new in
                    update(sorting: sorting, filter: filter, tasks: new)
                }
                .store(in: &cancellables)
        }

        func removeTask(with id: TD.Task.ID) {
            dataBase.removeTask(with: id)
        }
    }
}

private extension MainView.ViewModel {
    func update(sorting: TD.Sorting, filter: TD.Filter, tasks new: [TD.Task]) {
        var new = new
        if !filter.showExpired {
            new.removeAll(where: \.isExpired)
        }

        groups = Self.applyGroupedFilter(sorting, on: new, and: groups)
        tasks = Self.applySorting(sorting, on: new)
    }

    static func applyGroupedFilter(_ sorting: TD.Sorting, on tasks: [TD.Task], and groups: [TD.Group]) -> [TD.Group] {
        return tasks
            .group(by: \.category)
            .map { key, value in
                let isExpanded: Bool = groups.first(where: { $0.id == key })?.isExpanded ?? true
                return .init(id: key, tasks: applySorting(sorting, on: value), isExpanded: isExpanded)
            }
            .sorted { lhs, rhs in
                return lhs.id < rhs.id
            }
    }

    static func applySorting(_ sorting: TD.Sorting, on tasks: [TD.Task]) -> [TD.Task] {
        return tasks
            .sorted { lhs, rhs in
                return sortedBy(sorting, lhs: lhs, rhs: rhs)
            }
    }

    static func sortedBy(_ sorting: TD.Sorting, lhs: TD.Task, rhs: TD.Task) -> Bool {
        switch sorting {
        case .byPriority:
            if lhs.priority != rhs.priority {
                return lhs.priority < rhs.priority
            }

            if lhs.dueDate != rhs.dueDate {
                return lhs.dueDate < rhs.dueDate
            }
        case .byDueDate:
            if lhs.dueDate != rhs.dueDate {
                return lhs.dueDate < rhs.dueDate
            }

            if lhs.priority != rhs.priority {
                return lhs.priority < rhs.priority
            }
        }

        if lhs.text != rhs.text {
            return lhs.text < rhs.text
        }

        if lhs.category != rhs.category {
            return lhs.category < rhs.category
        }

        return lhs.id < rhs.id
    }
}
