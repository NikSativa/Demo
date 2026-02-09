import SwiftUI

struct TaskView: View {
    @iVModel
    var viewModel: ViewModel
    @Environment(\.dismiss)
    var dismissAction

    /// add new task
    init() {
        _viewModel = .init(with: [TD.Task.new, false])
    }

    /// edit existing
    init(editTask task: TD.Task) {
        _viewModel = .init(with: [task, true])
    }

    var body: some View {
        ZStack {
            form()
            bottom()
        }
        .navigationTitle(viewModel.isEditing ? "taskView.update.title" : "taskView.add.title")
    }

    private func form() -> some View {
        Form {
            TextField("taskView.text.placeholder", text: $viewModel.task.text)
                .textFieldStyle(.roundedBorder)

            DatePicker(selection: $viewModel.task.dueDate,
                       in: (Date.now + 60)...,
                       displayedComponents: [.date, .hourAndMinute]) {
                Text("taskView.dueDate.placeholder")
                    .textStyle()
            }

            Picker(selection: $viewModel.task.priority) {
                ForEach(TD.Priority.allCases, id: \.self) { size in
                    Text(size.displayName)
                        .textStyle()
                        .tag(size)
                }
            } label: {
                Text("taskView.priority.label")
                    .textStyle()
            }
            .pickerStyle(.menu)

            Picker(selection: $viewModel.task.category) {
                ForEach(viewModel.allCategories, id: \.id) { item in
                    Text(item.displayName)
                        .textStyle()
                        .tag(item)
                }

                Text("taskView.category.other.displayName")
                    .textStyle(with: .Td.blue, weight: .bold)
                    .tag(TD.Category.other)
            } label: {
                Text("taskView.category.label")
                    .textStyle()
            }
            .pickerStyle(.menu)

            if viewModel.task.category.isCustom {
                TextField("taskView.category.other.placeholder", text: $viewModel.customCategoryName)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .formStyle(.grouped)
    }

    private func bottom() -> some View {
        VStack {
            Spacer()

            Button(action: {
                if viewModel.mainButtonTappedAndNeedClose() {
                    dismissAction.callAsFunction()
                }
            }) {
                HStack {
                    Spacer()
                    Text(viewModel.isEditing ? "taskView.button.update.label" : "taskView.button.add.label")
                        .textStyle(with: .Td.white)
                        .padding(20)
                    Spacer()
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .background(Color.Td.blue)
        }
    }
}

private extension TD.Category {
    static let other: Self = .init(id: "other")
}

#Preview {
    TaskView()
        .previewEnvironment()
}
