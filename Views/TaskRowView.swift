import Foundation
import SwiftUI

struct TaskRowView: View {
    @Binding
    var task: TD.Task
    let action: SetClosure<TD.Task.ID>

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(task.dueDateString)
                    .textStyle(with: .Td.gray, size: 14)

                Text(task.text)
                    .textStyle(size: 16)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                if task.isExpired {
                    Text("task.status.expired")
                        .textStyle(with: .Td.realWhite, size: 9, weight: .bold)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background {
                            Capsule(style: .continuous).fill(Color.Td.red)
                        }
                }

                Text(task.priority.displayName)
                    .textStyle(with: .Td.gray, size: 16)
            }
        }
        .swipeActions(allowsFullSwipe: true) {
            Button(role: .destructive) {
                action(task.id)
            } label: {
                AppSymbol.deleteTask.imageView(.Td.realWhite)
            }
            .tint(.Td.red)
        }
    }
}

#Preview {
    TaskRowView(task: .constant(.init(text: "name", dueDate: .now)), action: { _ in })
        .devStroke()
        .padding()
}
