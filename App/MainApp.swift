import SwiftUI

@main
struct MainApp: App {
    private let container: AppContainer = .init()

    var body: some Scene {
        WindowGroup {
            if AppConstant.isRunningForTests {
                EmptyView()
            } else {
                NavigationView {
                    MainView()
                }
                .realEnvironment(container)
            }
        }
    }
}
