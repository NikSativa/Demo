import Combine
import SpryKit
import StorageKit
import XCTest

@testable import TODOish

@MainActor
final class MainView_ViewModelTests: XCTestCase {
    @Defaults(key: "tests.sorting")
    private var sorting: TD.Sorting = .default

    @Defaults(key: "tests.filter")
    private var filter: TD.Filter = .default

    private lazy var db = FakeDBManager()
    private lazy var tasksSubject: ValueSubject<[TD.Task]> = .init([])
    private lazy var subject: MainView.ViewModel = .init(dataBase: db, sorting: _sorting, filter: _filter)

    private let task1 = TD.Task(text: "1", dueDate: .now + 120, category: .home, priority: .medium)
    private let task2 = TD.Task(text: "2", dueDate: .now - 120, category: .home, priority: .high)
    private let task3 = TD.Task(text: "3", dueDate: .now + 120, category: .personal, priority: .low)
    private let task4 = TD.Task(text: "4", dueDate: .now - 120, category: .personal, priority: .high)

    private func setUpSubject(file: StaticString = #filePath, line: UInt = #line) {
        db.stub(.tasksPublisher).andReturn(tasksSubject.eraseToAnyPublisher())

        XCTAssertEqual(subject.tasks, [], file: file, line: line)
        XCTAssertEqual(subject.groups, [], file: file, line: line)

        XCTAssertHaveReceived(db, .tasksPublisher, countSpecifier: .exactly(1), file: file, line: line)

        XCTAssertFalse(task1.isExpired, file: file, line: line)
        XCTAssertTrue(task2.isExpired, file: file, line: line)
        XCTAssertFalse(task3.isExpired, file: file, line: line)
        XCTAssertTrue(task4.isExpired, file: file, line: line)

        db.resetCallsAndStubs()
    }

    func test_showExpired_byDueDate() {
        setUpSubject()

        filter.showExpired = true
        sorting = .byDueDate
        tasksSubject.send([task1, task2, task3, task4])

        XCTAssertEqual(subject.tasks, [task2, task4, task1, task3], subject.tasks.testTexts)
        XCTAssertEqual(subject.groups, [
            .init(id: .home, tasks: [task2, task1]),
            .init(id: .personal, tasks: [task4, task3])
        ])
    }

    func test_hideExpired_byDueDate() {
        setUpSubject()

        filter.showExpired = false
        sorting = .byDueDate
        tasksSubject.send([task1, task2, task3, task4])

        XCTAssertEqual(subject.tasks, [task1, task3], subject.tasks.testTexts)
        XCTAssertEqual(subject.groups, [
            .init(id: .home, tasks: [task1]),
            .init(id: .personal, tasks: [task3])
        ])
    }

    func test_showExpired_byPriority() {
        setUpSubject()

        filter.showExpired = true
        sorting = .byPriority
        tasksSubject.send([task1, task2, task3, task4])

        XCTAssertEqual(subject.tasks, [task3, task1, task2, task4], subject.tasks.testTexts)
        XCTAssertEqual(subject.groups, [
            .init(id: .home, tasks: [task1, task2]),
            .init(id: .personal, tasks: [task3, task4])
        ])
    }

    func test_hideExpired_byPriority() {
        setUpSubject()

        filter.showExpired = false
        sorting = .byPriority
        tasksSubject.send([task1, task2, task3, task4])

        XCTAssertEqual(subject.tasks, [task3, task1], subject.tasks.testTexts)
        XCTAssertEqual(subject.groups, [
            .init(id: .home, tasks: [task1]),
            .init(id: .personal, tasks: [task3])
        ])
    }

    func test_removeTask() {
        setUpSubject()

        db.stub(.removeTaskWithWith).andReturn()
        subject.removeTask(with: task1.id)
        XCTAssertHaveReceived(db, .removeTaskWithWith, with: task1.id)
    }
}

private extension TD.Group {
    init(id: TD.Category, tasks: [TD.Task]) {
        self.init(id: id, tasks: tasks, isExpanded: true)
    }
}

private extension [TD.Task] {
    @MainActor
    var testTexts: String {
        return "[" + map(\.text).joined(separator: ", ") + "]"
    }
}
