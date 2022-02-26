public protocol CardTransitionProvider {
    var dataSource: CardPresentationControllerDataSource? { get }
    var delegate: CardPresentationControllerDelegate? { get }
}

extension CardTransitionProvider {
    public var dataSource: CardPresentationControllerDataSource? { nil }
    public var delegate: CardPresentationControllerDelegate? { nil }
}
