public protocol CardPresentationControllerDelegate: AnyObject {
    func cardPresentationControllerTitle(_ cardPresentationController: CardPresentationController) -> String?
    func cardPresentationController(_ cardPresentationController: CardPresentationController, shouldDismissBy reason: CardDismissingReason) -> Bool
    func cardPresentationController(_ cardPresentationController: CardPresentationController, didDismissBy reason: CardDismissingReason)
}

extension CardPresentationControllerDelegate {
    public func cardPresentationControllerTitle(_ cardPresentationController: CardPresentationController) -> String? { nil }
    public func cardPresentationController(_ cardPresentationController: CardPresentationController, shouldDismissBy reason: CardDismissingReason) -> Bool { true }
    public func cardPresentationController(_ cardPresentationController: CardPresentationController, didDismissBy reason: CardDismissingReason) { }
}
