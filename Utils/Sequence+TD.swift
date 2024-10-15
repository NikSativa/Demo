import Foundation

extension Sequence {
    func group<Key: Hashable>(by key: (Iterator.Element) -> Key) -> [Key: [Iterator.Element]] {
        var groups: [Key: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            var cached = groups[key] ?? []
            cached.append(element)
            groups[key] = cached
        }
        return groups
    }
}
