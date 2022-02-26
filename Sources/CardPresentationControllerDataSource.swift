public protocol CardPresentationControllerDataSource: AnyObject {
    func title(for cardPresentationController: CardPresentationController) -> String?
}

extension CardPresentationControllerDataSource {
    public func title(for cardPresentationController: CardPresentationController) -> String? { nil }
}
