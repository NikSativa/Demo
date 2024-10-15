import SpryKit
import StorageKit

@testable import TODOish

@Spryable
final class FakeDBManager: DBManager {
    @SpryableVar
    var tasksPublisher: ValuePublisher<[TD.Task]>

    @SpryableVar
    var tasks: [TD.Task]

    @SpryableFunc
    func addTask(_ task: TD.Task)

    @SpryableFunc
    func removeTask(with id: TD.Task.ID)

    @SpryableFunc
    func mockify()
}
