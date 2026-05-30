enum ViewState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(String)
}
