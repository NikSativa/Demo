import SpryKit
import StorageKit
@testable import TODOish

@Spryable
final class FakeAlertPresenter: AlertPresenter {
    @SpryableFunc
    func show(_ error: Error)
}
