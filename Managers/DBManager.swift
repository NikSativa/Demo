import Combine
import StorageKit
import SwiftUI

@MainActor
protocol DBManager {
    var tasksPublisher: ValuePublisher<[TD.Task]> { get }
    var tasks: [TD.Task] { get }

    func addTask(_ task: TD.Task)
    func removeTask(with id: TD.Task.ID)

    /// **ONLY FOR PREVIEW**
    func mockify()
}

// MARK: - Impl.DBManager

extension Impl {
    @MainActor
    final class DBManager {
        private let storage: AnyStorage<[TD.Task]?>
        private var timer: Timer?

        var tasksPublisher: ValuePublisher<[TD.Task]> {
            return storage.eventier.map { $0 ?? [] }.eraseToAnyPublisher()
        }

        var tasks: [TD.Task] {
            didSet {
                if oldValue != tasks {
                    saveTasks()
                }
            }
        }

        /// **storage** parameter only for testing purposes
        init(tasks: [TD.Task] = [],
             storage: AnyStorage<[TD.Task]?>) {
            self.tasks = tasks
            self.storage = storage

            if tasks.isEmpty {
                fetchTasks()
            }

            scheduleUpdate()
        }
    }
}

// MARK: - Impl.DBManager + DBManager

extension Impl.DBManager: DBManager {
    func addTask(_ task: TD.Task) {
        let index = tasks.firstIndex { cached in
            return cached.id == task.id
        }

        if let index {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
    }

    func removeTask(with id: TD.Task.ID) {
        tasks.removeAll { task in
            return task.id == id
        }
    }
}

private extension Impl.DBManager {
    func scheduleUpdate() {
        let now = Date.now
        updateAccordingToDate(now)

        // schedule next minute
        let calendar = Calendar.current
        let seconds = calendar.component(.second, from: now)
        let diff = min(60, max(0, 60 - seconds))

        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(diff), repeats: false) { [weak self] _ in
            guard let self else {
                return
            }

            if Thread.isMainThread {
                MainActor.assumeIsolated {
                    self.scheduleUpdate()
                }
            } else {
                DispatchQueue.main.sync {
                    self.scheduleUpdate()
                }
            }
        }
    }

    func stopTimer() {
        if let timer, timer.isValid {
            timer.invalidate()
        }
        timer = nil
    }

    func updateAccordingToDate(_ date: Date) {
        tasks = tasks.map { task in
            var task = task
            task.updateAccordingToDate(date)
            return task
        }
    }

    func fetchTasks() {
        let new = storage.value ?? []
        if new != tasks {
            tasks = new
        }
    }

    func saveTasks() {
        if AppConstant.isRunningForPreviews {
            // disable cache for preview mode
            return
        }
        storage.value = tasks
    }
}

extension Impl.DBManager {
    /// **ONLY FOR PREVIEW**
    func mockify() {
        assert(AppConstant.isRunningForPreviews, "This method should be used only for previews")
        let priorities = TD.Priority.allCases
        let now = Date.now

        let categorizedTasks: (TD.Category) -> [TD.Task] = { category in
            return [
                .init(text: "now", dueDate: now, category: category, priority: priorities.randomElement()!),
                .init(text: "expired task", dueDate: now.addingTimeInterval(-3600), category: category, priority: priorities.randomElement()!),
                .init(text: "+1h", dueDate: now.addingTimeInterval(3600), category: category, priority: priorities.randomElement()!),
                .init(text: "+3sec", dueDate: now.addingTimeInterval(3), category: category, priority: priorities.randomElement()!)
            ]
        }

        var tasks: [TD.Task] = []
        tasks += TD.Category.allCases.flatMap {
            return categorizedTasks($0)
        }

        let uncategorizedTasks: [TD.Task] = (0..<100).map { i in
            return .init(text: "some_\(i)", dueDate: now.addingTimeInterval(TimeInterval(i * 3600)), category: .undefined, priority: priorities.randomElement()!)
        }
        tasks += uncategorizedTasks

        self.tasks = tasks
    }
}

private extension TD.Category {
    static let undefined: Self = .init(id: "undefined")
}
