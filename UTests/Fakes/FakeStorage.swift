import SpryKit
import StorageKit

@Spryable
final class FakeStorage<Value>: Storage {
    @SpryableVar
    var eventier: StorageKit.ValuePublisher<Value>

    @SpryableVar(.get, .set)
    var value: Value
}
