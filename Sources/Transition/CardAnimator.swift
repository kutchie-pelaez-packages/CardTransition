import Core
import UIKit

public final class CardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public init(direction: CardTransitionDirection) {
        self.direction = direction
        super.init()
    }

    private let direction: CardTransitionDirection

    // MARK: -

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let presentedView: UIView?
        switch direction {
        case .presenting:
            presentedView = transitionContext.view(forKey: .to)

        case .dismissing:
            presentedView = transitionContext.view(forKey: .from)
        }

        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: .easeInOut,
            animations: { [weak self, weak presentedView] in
                guard
                    let self = self,
                    let presentedView = presentedView
                else {
                    return
                }

                switch self.direction {
                case .presenting:
                    presentedView.transform = .identity

                case .dismissing:
                    presentedView.transform = CGAffineTransform(
                        translationX: 0,
                        y: presentedView.frame.height
                    )
                }
            }
        )
        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        switch direction {
        case .presenting: return CardTransitionConstants.Timings.presenting
        case .dismissing: return CardTransitionConstants.Timings.dismissing
        }
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = animator(using: transitionContext)
        animator.startAnimation()
    }

    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        animator(using: transitionContext)
    }
}
