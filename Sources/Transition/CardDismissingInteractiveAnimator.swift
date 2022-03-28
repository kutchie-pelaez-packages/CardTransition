import CoreUI
import UIKit

public final class CardDismissingInteractiveAnimator: UIPercentDrivenInteractiveTransition {
    weak var presentationController: CardPresentationController!
    weak var presentingViewController: UIViewController?
    weak var presentedViewController: UIViewController?

    private var transitionContext: UIViewControllerContextTransitioning?
    private weak var panGestureRecognizer: UIPanGestureRecognizer?

    var card: UIView? {
        didSet {
            guard let card = card else { return }

            addGesturesIfNeeded(for: card)
        }
    }

    private var cardPresentationControllerDelegate: CardPresentationControllerDelegate? {
        presentedViewController as? CardPresentationControllerDelegate
    }

    // MARK: -

    private var canDismissByGesture: Bool {
        cardPresentationControllerDelegate?.cardPresentationController(
            presentationController,
            shouldDismissBy: .gesture
        ) == true
    }

    private func addGesturesIfNeeded(for card: UIView) {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addAction { [unowned self, unowned panGestureRecognizer, unowned card] in
            self.handleDismissingPanGesture(gesture: panGestureRecognizer, card: card)
        }
        card.addGestureRecognizer(panGestureRecognizer)

        self.panGestureRecognizer = panGestureRecognizer
    }

    private func handleDismissingPanGesture(gesture: UIPanGestureRecognizer, card: UIView) {
        let translation = gesture.translation(in: card).y
        let velocity = gesture.velocity(in: card).y

        let cardHeight = card.frame.height
        let percentTranslated = translation / cardHeight

        switch gesture.state {
        case .began:
            pause()

            if percentComplete == .zero  {
                presentedViewController?.dismiss(animated: true) { [weak self] in
                    guard
                        let self = self,
                        self.transitionContext?.transitionWasCancelled == false
                    else {
                        return
                    }

                    self.cardPresentationControllerDelegate?.cardPresentationController(
                        self.presentationController,
                        didDismissBy: .gesture
                    )
                }
            }

        case .changed:
            if translation > .zero {
                update(percentTranslated)
            } else if translation < .zero {
                card.transform = CGAffineTransform(
                    translationX: .zero,
                    y: -pow(-translation, 0.8) + cardHeight
                )
            } else {
                update(.zero)
            }

        case .ended, .cancelled:
            if
                canDismissByGesture &&
                (velocity >= CardTransitionConstants.Misc.velocityThreshold ||
                percentComplete >= CardTransitionConstants.Misc.percentCompleteThreshold)
            {
                finish()
            } else {
                if translation >= .zero {
                    cancel()
                } else {
                    animation(duration: CardTransitionConstants.Timings.returning) {
                        self.card?.transform = CGAffineTransform(
                            translationX: .zero,
                            y: cardHeight
                        )
                    }
                }
            }

        case .failed: cancel()
        case .possible: break
         @unknown default: break
        }
    }

    // MARK: - UIViewControllerInteractiveTransitioning

    public override var wantsInteractiveStart: Bool {
        get { panGestureRecognizer?.state == .began }
        set { }
    }

    public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
}
