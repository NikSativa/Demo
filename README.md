# Demo TODOish

This app is a simple task manager that allows you to add, edit, and delete tasks. It uses **DIKit** for dependency injection and **SpryKit** for testing.
The main purpose of this app is to show how to use **DIKit** and **SpryKit** in a **SwiftUI** project. 
It is not a full-featured app, but it is a good starting point for your own project.

The most important points of this project are:
* **SwiftUI.Preview** is perfectly working in any place of the project because of the `DIKit.container`.
* `DIKit.container` is placed in the environment and can resolve dependencies based on protocols instead of concrete types which is restricted by SwiftUI.
* `SpryKit` is used for mocking dependencies in tests. It is a good practice to create fake objects for all dependencies in tests. It makes tests more reliable and faster. **SpryKit** is a great tool for that! It helps to generate fake objects automatically using **macros**.
* `StorageKit` is a simple wrapper around `UserDefaults` that allows you to store and retrieve objects in a type-safe way. It represents that you can use your own frameworks and make SpryKit-friendly for testing.

See some examples:
- "View+DI" - how to use `DIKit.container` in SwiftUI views/previews
- "AppContainer" - how to register dependencies in the container using assemblies
- "SharedTypes" - how to share types for whole project and don't flood project with imports
- "DBManager" - is a protocol for `DBManager` class, so you can **easily mock it in tests**. see `FakeDBManager`
- protocol "ViewModeling" and property wrapper `iVModel` - how to inject view models into views
- "MainView.ViewModel" and "TaskView.ViewModel" - how to create complex view model and use it in the view. Main point is to **inject dependencies into the view model** instead of View - it makes testing easier and cleaner. **In that way View is responsible only for rendering data and handling user interactions**.
- "TaskView.ViewModelTests" and "MainView.ViewModelTests" - how to test view models with **SpryKit** and how to mock dependencies using fake object which is generated automatically by **SpryKit**.
- "FakeDBManager" - how to create fake objects for tests. 
