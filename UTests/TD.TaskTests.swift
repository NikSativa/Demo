import XCTest
@testable import TODOish

@MainActor
final class TD_TaskTests: XCTestCase {
    func test_expiration() {
        var subject: TD.Task = .init(text: "1", dueDate: .now)
        XCTAssertTrue(subject.isExpired)

        subject = .init(text: "1", dueDate: .now - 1)
        XCTAssertTrue(subject.isExpired)

        subject = .init(text: "1", dueDate: .now + 1)
        XCTAssertFalse(subject.isExpired)
    }
}
