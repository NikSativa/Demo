import XCTest

@testable import TODOish

final class SequenceTests: XCTestCase {
    private struct Testable: Hashable, ExpressibleByIntegerLiteral {
        let value: Int

        init(integerLiteral value: Int) {
            self.value = value
        }
    }

    func test_grouped() {
        var array: [Testable] = []
        XCTAssertEqual(array.group(by: \.value), [:])

        array = [1]
        XCTAssertEqual(array.group(by: \.value), [1: [1]])

        array = [1, 2, 3, 4]
        XCTAssertEqual(array.group(by: \.value), [1: [1], 2: [2], 3: [3], 4: [4]])

        array = [1, 1, 2, 2, 2, 3, 4]
        XCTAssertEqual(array.group(by: \.value), [1: [1, 1], 2: [2, 2, 2], 3: [3], 4: [4]])
    }
}
