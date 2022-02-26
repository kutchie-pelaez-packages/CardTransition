public protocol CardPresentationControllerDelegate: AnyObject {
    func cardPresentationController(_ cardPresentationController: CardPresentationController, shouldDismissBy dismissingReason: CardDismissingReason) -> Bool
    func cardPresentationController(_ cardPresentationController: CardPresentationController, didDismissBy dismissingReason: CardDismissingReason)
}

extension CardPresentationControllerDelegate {
    public func cardPresentationController(_ cardPresentationController: CardPresentationController, shouldDismissBy dismissingReason: CardDismissingReason) -> Bool { true }
    public func cardPresentationController(_ cardPresentationController: CardPresentationController, didDismissBy dismissingReason: CardDismissingReason) { }
}
