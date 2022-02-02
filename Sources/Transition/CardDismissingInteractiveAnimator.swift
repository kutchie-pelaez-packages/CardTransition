import UIKit

private let velocityThreshold: Double = 300
private let percentCompleteThreshold: Double = 0.5

public final class CardDismissingInteractiveAnimator:
    UIPercentDrivenInteractiveTransition,
    UIScrollViewDelegate
{

    private var transitionContext: UIViewControllerContextTransitioning?
    weak var presentingViewController: UIViewController?
    weak var presentedViewController: UIViewController?
    weak var scrollView: UIScrollView? {
        didSet {
            panGesture?.addAction { [weak self] in
                guard let panGesture = self?.panGesture else { return }

                self?.handleDismissingPanGesture(panGesture)
            }
        }
    }

    private var card: UIView? {
        scrollView?.subviews.last?.subviews.first
    }

    private var panGesture: UIPanGestureRecognizer? {
        scrollView?.gestureRecognizers?
            .compactMap { $0 as? UIPanGestureRecognizer }
            .first
    }

    private var cardDelegate: CardViewControllerCompatible? {
        presentedViewController as? CardViewControllerCompatible
    }

    // MARK: -

    private func handleDismissingPanGesture(_ pan: UIPanGestureRecognizer) {
        guard
            let scrollView = scrollView,
            let card = card,
            cardDelegate?.cardCanCloseInteractive == true
        else {
            return
        }

        let translation = pan.translation(in: scrollView).y
        let velocity = pan.velocity(in: scrollView).y

        let cardHeight = card.frame.height
        let maxTranslation = cardHeight + cardEdgeInset
        let offset = scrollView.contentOffset.y
        let percentTranslated = translation / maxTranslation

        switch pan.state {
        case .began:
            pause()

            pan.setTranslation(
                CGPoint(
                    x: .zero,
                    y: offset
                ),
                in: scrollView
            )

            if percentComplete == .zero  {
                presentedViewController?.dismiss(animated: true) { [weak self] in
                    guard self?.transitionContext?.transitionWasCancelled == false else { return }

                    self?.cardDelegate?.cardDidCloseInteractive()
                }
            }

        case .changed:
            if translation > .zero {
                scrollView.contentOffset = .zero
                update(percentTranslated)
            } else {
                update(.zero)
            }

        case .ended, .cancelled:
            if velocity <= -velocityThreshold {
                cancel()
            } else if
                velocity >= velocityThreshold ||
                percentComplete >= percentCompleteThreshold
            {
                finish()
            } else {
                cancel()
            }

        case .failed:
            cancel()

        case .possible:
            break

         @unknown default:
            break
        }
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool { false }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard cardDelegate?.cardCanCloseInteractive == true else { return }
        
        if scrollView.contentOffset.y < .zero {
            scrollView.contentOffset.y = .zero
        }
    }

    // MARK: - UIViewControllerInteractiveTransitioning

    public override var wantsInteractiveStart: Bool {
        get {
            panGesture?.state == .began
        } set { }
    }


    public override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
}
