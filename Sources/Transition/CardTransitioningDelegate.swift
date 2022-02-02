import UIKit

public final class CardTransitioningDelegate:
    NSObject,
    UIViewControllerTransitioningDelegate
{

    private let presentingAnimator = CardAnimator(direction: .presenting)
    private let dismissingAnimator = CardAnimator(direction: .dismissing)
    private let dismissingInteractiveAnimator = CardDismissingInteractiveAnimator()

    // MARK: - UIViewControllerTransitioningDelegate

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentingAnimator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissingAnimator
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        nil
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        dismissingInteractiveAnimator
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CardPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source
        )
        presentationController.link(dismissingInteractiveAnimator)

        return presentationController
    }
}
