import Combine
import SpryKit
import StorageKit
import XCTest
@testable import TODOish

@MainActor
final class TaskView_ViewModelTests: XCTestCase {
    private lazy var db = FakeDBManager()
    private lazy var alertPresenter: FakeAlertPresenter = .init()
    private var subject: TaskView.ViewModel!

    private func setUpSubject(task: TD.Task,
                              isEditing: Bool,
                              file: StaticString = #filePath,
                              line: UInt = #line) {
        subject = .init(dataBase: db, alertPresenter: alertPresenter, task: task, isEditing: isEditing)
    }

    func test_new_isEditing() {
        let task = TD.Task.new
        setUpSubject(task: task, isEditing: true)
        XCTAssertEqual(subject.customCategoryName, "")
        XCTAssertTrue(subject.isEditing)
        XCTAssertEqual(subject.task, task)

        run_test_mainButtonTappedAndNeedClose()
        run_test_allCategories()
    }

    func test_new_isNotEditing() {
        let task = TD.Task.new
        setUpSubject(task: task, isEditing: false)
        XCTAssertEqual(subject.customCategoryName, "")
        XCTAssertFalse(subject.isEditing)
        XCTAssertEqual(subject.task, task)

        run_test_mainButtonTappedAndNeedClose()
        run_test_allCategories()
    }

    func test_custom_isEditing() {
        let task = TD.Task(text: "name", dueDate: .now, category: "category name")
        setUpSubject(task: task, isEditing: true)
        XCTAssertEqual(subject.customCategoryName, "category name")
        XCTAssertTrue(subject.isEditing)
        XCTAssertEqual(subject.task, task)

        run_test_mainButtonTappedAndNeedClose()
        run_test_allCategories()
    }

    func test_custom_isNotEditing() {
        let task = TD.Task(text: "name", dueDate: .now, category: "category name")
        setUpSubject(task: task, isEditing: false)
        XCTAssertEqual(subject.customCategoryName, "category name")
        XCTAssertFalse(subject.isEditing)
        XCTAssertEqual(subject.task, task)

        run_test_mainButtonTappedAndNeedClose()
        run_test_allCategories()
    }

    private func run_test_mainButtonTappedAndNeedClose(file: StaticString = #filePath,
                                                       line: UInt = #line) {
        run_save_task(.init(text: "name", dueDate: .now + 240), error: nil)

        run_save_task(.init(text: "name", dueDate: .now + 40), error: .dueDateLessThan1min)
        run_save_task(.init(text: "name", dueDate: .now - 40), error: .dueDateLessThan1min)
        run_save_task(.init(text: "name", dueDate: .now), error: .dueDateLessThan1min)

        run_save_task(.init(text: "", dueDate: .now + 40), error: .emptyTaskText)
        run_save_task(.init(text: "", dueDate: .now - 40), error: .emptyTaskText)
        run_save_task(.init(text: "", dueDate: .now), error: .emptyTaskText)

        run_save_task(.init(text: .init(repeating: "a", count: 29), dueDate: .now + 240), error: nil)
        run_save_task(.init(text: .init(repeating: "a", count: 30), dueDate: .now + 240), error: nil)
        run_save_task(.init(text: .init(repeating: "a", count: 31), dueDate: .now + 240), error: .taskTextGreaterThan30Chars)
        run_save_task(.init(text: .init(repeating: "a", count: 32), dueDate: .now + 240), error: .taskTextGreaterThan30Chars)

        run_save_task(.init(text: "name", dueDate: .now + 240, category: ""), error: .emptyCustomCategory)
        run_save_task(.init(text: "name", dueDate: .now + 240, category: "category name"), error: nil)
    }

    private func run_save_task(_ task: TD.Task,
                               error: TD.Error?,
                               file: StaticString = #filePath,
                               line: UInt = #line) {
        db.resetCallsAndStubs()
        alertPresenter.resetCallsAndStubs()

        subject.task = task
        subject.customCategoryName = task.category.id

        if let error {
            alertPresenter.stub(.showWithError).with(error).andReturn()
            XCTAssertFalse(subject.mainButtonTappedAndNeedClose())
            XCTAssertHaveReceived(alertPresenter, .showWithError, countSpecifier: .exactly(1), file: file, line: line)
        } else {
            if subject.isEditing {
                db.stub(.removeTaskWithWith).with(task.id).andReturn()
            }

            db.stub(.addTaskWithTask).with(task).andReturn()
            XCTAssertTrue(subject.mainButtonTappedAndNeedClose())

            if subject.isEditing {
                XCTAssertHaveReceived(db, .removeTaskWithWith, countSpecifier: .exactly(1), file: file, line: line)
            }
            XCTAssertHaveReceived(db, .addTaskWithTask, countSpecifier: .exactly(1), file: file, line: line)
        }
    }

    private func run_test_allCategories(file: StaticString = #filePath,
                                        line: UInt = #line) {
        // allCategories
        db.resetCallsAndStubs()
        db.stub(.tasks).andReturn([])
        XCTAssertEqual(subject.allCategories, TD.Category.allCases, file: file, line: line)
        XCTAssertHaveReceived(db, .tasks, countSpecifier: .exactly(1), file: file, line: line)

        // db has task with known category
        db.resetCallsAndStubs()
        db.stub(.tasks).andReturn([TD.Task.new])
        XCTAssertEqual(subject.allCategories, TD.Category.allCases, file: file, line: line)
        XCTAssertHaveReceived(db, .tasks, countSpecifier: .exactly(1), file: file, line: line)

        // db has task with unknown category
        db.resetCallsAndStubs()
        let customTask = TD.Task(text: "name", dueDate: .now, category: "category name")
        db.stub(.tasks).andReturn([customTask])
        XCTAssertEqual(subject.allCategories, TD.Category.allCases + [customTask.category], file: file, line: line)
        XCTAssertHaveReceived(db, .tasks, countSpecifier: .exactly(1), file: file, line: line)

        // db has task with mixed categories
        db.resetCallsAndStubs()
        let customTask2 = TD.Task(text: "name 2", dueDate: .now, category: "category name 2")
        db.stub(.tasks).andReturn([TD.Task.new, customTask, TD.Task.new, customTask2, TD.Task.new])
        XCTAssertEqual(subject.allCategories, TD.Category.allCases + [customTask.category, customTask2.category], file: file, line: line)
        XCTAssertHaveReceived(db, .tasks, countSpecifier: .exactly(1), file: file, line: line)
    }
}
