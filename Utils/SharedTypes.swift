import Combine
import DIKit
import Foundation

/// base contract for all view models
protocol ViewModeling: ObservableObject {}
typealias iVModel<T: ViewModeling> = DIKit.DIStateObject<T>

/// any manager
typealias iObsObj = DIKit.DIStateObject

/// any state or protocol
typealias iLazy = DIKit.DIState
/// anything
typealias iProvider = DIKit.DIProvider

typealias VoidClosure = () -> Void
typealias SetClosure<A> = (A) -> Void
typealias GetClosure<A> = () -> A

typealias AnyCancellable = Combine.AnyCancellable
