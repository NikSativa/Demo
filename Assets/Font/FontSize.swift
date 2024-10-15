import Foundation

struct FontSize: Equatable {
    static let `default`: Self = 17.0

    let value: CGFloat

    private init(value: CGFloat) {
        assert(value >= 8 && value <= 40, "Font size must be between 8 and 40")
        self.value = value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension FontSize: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.init(value: CGFloat(value))
    }
}

// MARK: - ExpressibleByFloatLiteral

extension FontSize: ExpressibleByFloatLiteral {
    init(floatLiteral value: Float) {
        self.init(value: CGFloat(value))
    }
}
