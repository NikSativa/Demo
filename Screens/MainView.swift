import SwiftUI

struct MainView: View {
    @iVModel
    var viewModel: ViewModel

    var body: some View {
        Group {
            if viewModel.tasks.isEmpty {
                noContent()
            } else {
                if viewModel.filter.groupedByCategory {
                    groupedContent()
                } else {
                    tasksContent()
                }
            }
        }
        .toolbar(content: toolbarContent)
        .navigationTitle("mainView.title")
    }

    private func noContent() -> some View {
        ContentUnavailableView {
            Text(viewModel.tasks.isEmpty ? "mainView.noContent" : "mainView.noContent.filtered")
                .textStyle(size: 20, weight: .medium)
                .padding(30)
        } actions: {
            NavigationLink(destination: TaskView.init) {
                Text("mainView.noContent.button.add")
                    .textStyle(with: .Td.realWhite)
                    .padding()
                    .background(Color.Td.blue, in: Capsule())
            }
        }
    }

    private func tasksContent() -> some View {
        List {
            ForEach($viewModel.tasks, content: rowView)
        }
    }

    private func groupedContent() -> some View {
        List {
            ForEach($viewModel.groups) { group in
                Section(isExpanded: group.isExpanded) {
                    ForEach(group.tasks, content: rowView)
                }
                header: {
                    SectionHeaderView(isExpanded: group.isExpanded, text: group.wrappedValue.displayName)
                }
            }
        }
    }

    private func toolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Menu(content: {
                Picker("mainView.sorting", selection: $viewModel.sorting) {
                    ForEach(TD.Sorting.allCases, id: \.self) { sorting in
                        Text(sorting.displayName).tag(sorting)
                    }
                }

                Toggle("mainView.filter.showExpired", isOn: $viewModel.filter.showExpired)
                Toggle("mainView.filter.groupedByCategory", isOn: $viewModel.filter.groupedByCategory)
            }, label: {
                AppSymbol.sorting.imageView()
            })

            NavigationLink(destination: TaskView.init) {
                AppSymbol.addNewTask.imageView()
            }
        }
    }

    private func rowView(_ task: Binding<TD.Task>) -> some View {
        NavigationLink(destination: {
            TaskView(editTask: task.wrappedValue)
        }) {
            TaskRowView(task: task, action: viewModel.removeTask(with:))
        }
    }
}

#Preview {
    MainView()
        .previewEnvironment()
}
