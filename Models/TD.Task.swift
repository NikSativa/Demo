import Foundation

// MARK: - TD.Task

extension TD {
    @MainActor
    struct Task: Identifiable, Hashable, Codable {
        let id: UUID
        var text: String
        var dueDate: Date
        var category: Category
        var priority: Priority
        var isExpired: Bool

        init(id: ID = .init(),
             text: String,
             dueDate: Date,
             category: Category = .default,
             priority: Priority = .default) {
            self.id = id
            self.text = text
            self.dueDate = dueDate
            self.category = category
            self.priority = priority
            self.isExpired = false

            updateAccordingToDate()
        }

        var dueDateString: String {
            let formatter = DateFormatter()
            formatter.dateStyle = dueDate.isToday ? .none : .medium
            formatter.timeStyle = .short
            return formatter.string(from: dueDate)
        }

        mutating func updateAccordingToDate(_ date: Date = .now) {
            isExpired = date > dueDate
        }

        static var new: Self {
            return .init(text: "", dueDate: .now + 120)
        }
    }
}

private extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}
