import Foundation

extension TD {
    enum Error: LocalizedError {
        case emptyTaskText
        case taskTextGreaterThan30Chars
        case dueDateLessThan1min
        case emptyCustomCategory

        var errorDescription: String? {
            switch self {
            case .emptyTaskText:
                return NSLocalizedString("localizedError.description.emptyTaskText", comment: "")
            case .taskTextGreaterThan30Chars:
                return NSLocalizedString("localizedError.description.taskTextGreaterThan30Chars", comment: "")
            case .dueDateLessThan1min:
                return NSLocalizedString("localizedError.description.dueDateLessThan1min", comment: "")
            case .emptyCustomCategory:
                return NSLocalizedString("localizedError.description.emptyCustomCategory", comment: "")
            }
        }
    }
}
