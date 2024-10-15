import XCTest

@testable import TODOish

final class CategoryTests: XCTestCase {
    func test_comparable() {
        var array: [TD.Category] = []
        XCTAssertEqual(array.sorted(), [])

        array = [.home, .personal, .work]
        XCTAssertEqual(array.sorted(), [.home, .personal, .work])

        array = [.init(id: "some"), .home, .personal, .work]
        XCTAssertEqual(array.sorted(), [.home, .personal, .work, .init(id: "some")])

        array = [.init(id: "some"), .home, .init(id: "A-some"), .personal, .work]
        XCTAssertEqual(array.sorted(), [.home, .personal, .work, .init(id: "A-some"), .init(id: "some")])

        array = [.init(id: "some"), .home, .init(id: "B-some"), .init(id: "A-some"), .personal, .work]
        XCTAssertEqual(array.sorted(), [.home, .personal, .work, .init(id: "A-some"), .init(id: "B-some"), .init(id: "some")])
    }
}
