import SpryKit
import XCTest
@testable import TODOish

@MainActor
final class DBManagerTests: XCTestCase {
    func test_db() {
        let task1 = TD.Task(text: "1", dueDate: .now + 2)
        XCTAssertFalse(task1.isExpired)

        let task2 = TD.Task(text: "2", dueDate: .now + 2)
        XCTAssertFalse(task2.isExpired)

        let storage = FakeStorage<[TD.Task]?>()
        // stub getter before init DB - fetch tasks on init
        storage.stub(.value_get).andReturn([])

        let subject: DBManager = Impl.DBManager(storage: storage.toAny())

        XCTAssertTrue(subject.tasks.isEmpty)
        XCTAssertHaveReceived(storage, .value_get, countSpecifier: .exactly(1))

        storage.resetCallsAndStubs()
        storage.stub(.value_set).with([task1]).andReturn()
        subject.addTask(task1)
        XCTAssertHaveReceived(storage, .value_set, with: [task1], countSpecifier: .exactly(1))
        XCTAssertEqual(subject.tasks, [task1])

        // reset stubs to be sure fake will never called
        storage.resetCallsAndStubs()

        // should nothing happen. task is already added and cached in memory
        subject.addTask(task1)
        XCTAssertEqual(subject.tasks, [task1])

        // should nothing happen. task is not yet added
        subject.removeTask(with: task2.id)
        XCTAssertEqual(subject.tasks, [task1])

        // remove task1
        storage.resetCallsAndStubs()
        storage.stub(.value_set).with([]).andReturn()
        subject.removeTask(with: task1.id)
        XCTAssertHaveReceived(storage, .value_set, with: [], countSpecifier: .exactly(1))
        XCTAssertEqual(subject.tasks, [])

        // add task1 and task2
        storage.resetCallsAndStubs()
        storage.stub(.value_set).andReturn()
        subject.addTask(task1)
        subject.addTask(task2)

        XCTAssertEqual(subject.tasks, [task1, task2])
        XCTAssertHaveReceived(storage, .value_set, countSpecifier: .exactly(2))
    }
}
