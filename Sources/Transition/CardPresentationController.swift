import Core
import CoreUI
import UIKit

public final class CardPresentationController: UIPresentationController {
    public func link(_ dismissingInteractiveAnimator: CardDismissingInteractiveAnimator) {
        self.dismissingInteractiveAnimator = dismissingInteractiveAnimator
        dismissingInteractiveAnimator.presentationController = self
        dismissingInteractiveAnimator.presentingViewController = presentingViewController
        dismissingInteractiveAnimator.presentedViewController = presentedViewController
    }

    private weak var dismissingInteractiveAnimator: CardDismissingInteractiveAnimator?

    // MARK: - UI

    private var shade: CardShadeView!
    private var card: CardView!

    private func setup() {
        configureViews()
        constraintViews()
    }

    private func configureViews() {
        shade = CardShadeView()
        containerView?.addSubviews(shade)

        card = CardView(
            presentationController: self,
            dataSource: dataSource,
            delegate: _delegate
        )
        containerView?.addSubviews(card)

        subjectView?.translatesAutoresizingMaskIntoConstraints = false
        card.addSubviews(subjectView)
    }

    private func constraintViews() {
        shade.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }

        card.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }

        subjectView?.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    private func postSetup() {
        presentedViewController.additionalSafeAreaInsets = presentingViewController.view.safeAreaInsets

        card.setNeedsLayout()
        card.layoutIfNeeded()
        card.transform = CGAffineTransform(
            translationX: 0,
            y: card.frame.height
        )
    }

    // MARK: -

    private var subjectView: UIView? {
        presentedViewController.view
    }

    private var provider: CardTransitionProvider? {
        presentedViewController as? CardTransitionProvider
    }

    private var dataSource: CardPresentationControllerDataSource? {
        if let provider = provider {
            return provider.dataSource
        } else {
            return presentedViewController as? CardPresentationControllerDataSource
        }
    }

    private var _delegate: CardPresentationControllerDelegate? {
        if let provider = provider {
            return provider.delegate
        } else {
            return presentedViewController as? CardPresentationControllerDelegate
        }
    }

    private func setPercentCompleteToShade(_ percentComplete: Double) {
        performAlongsideTransitionIfPossible { [weak self] in
            self?.shade.percentComplete = percentComplete
        }
    }

    private func performAlongsideTransitionIfPossible(_ block: @escaping Block) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            safeCrash()
            block()
            return
        }

        coordinator.animate(
            alongsideTransition: { _ in
                block()
            },
            completion: nil
        )
    }

    // MARK: - UIPresentationController

    public override var presentedView: UIView? { card }

    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        setup()
        postSetup()
        dismissingInteractiveAnimator?.card = card
        setPercentCompleteToShade(1)
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        setPercentCompleteToShade(0)
    }
}
