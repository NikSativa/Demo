import Foundation

// MARK: - TaskView.ViewModel

extension TaskView {
    @Observable
    final class ViewModel: ViewModeling {
        private let dataBase: DBManager
        private let alertPresenter: AlertPresenter

        var task: TD.Task
        let isEditing: Bool
        var customCategoryName: String = ""

        init(dataBase: DBManager,
             alertPresenter: AlertPresenter,
             task: TD.Task,
             isEditing: Bool) {
            self.dataBase = dataBase
            self.alertPresenter = alertPresenter
            self.task = task
            self.isEditing = isEditing

            self.customCategoryName = task.category.isCustom ? task.category.id : ""
        }
    }
}

extension TaskView.ViewModel {
    var allCategories: [TD.Category] {
        return Set(dataBase.tasks.map(\.category) + TD.Category.allCases).sorted(by: <)
    }

    func mainButtonTappedAndNeedClose() -> Bool {
        do {
            let task = try taskToSave()
            if isEditing {
                dataBase.removeTask(with: task.id)
            }
            dataBase.addTask(task)

            return true
        } catch {
            alertPresenter.show(error)
            return false
        }
    }

    private func taskToSave() throws -> TD.Task {
        if task.text.isEmpty {
            throw TD.Error.emptyTaskText
        }

        if task.text.count > 30 {
            throw TD.Error.taskTextGreaterThan30Chars
        }

        if task.dueDate < (Date.now + 60) {
            throw TD.Error.dueDateLessThan1min
        }

        task.isExpired = false
        task.category = try selectedCategory()
        return task
    }

    private func selectedCategory() throws -> TD.Category {
        if task.category.isCustom {
            if customCategoryName.isEmpty {
                throw TD.Error.emptyCustomCategory
            } else {
                return .init(id: customCategoryName)
            }
        } else {
            return task.category
        }
    }
}
