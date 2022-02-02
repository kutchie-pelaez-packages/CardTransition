import Core
import CoreUI
import DeviceKit
import UIKit

let cardEdgeInset: Double = 6

public final class CardPresentationController: UIPresentationController {
    public func link(_ dismissingInteractiveAnimator: CardDismissingInteractiveAnimator) {
        self.dismissingInteractiveAnimator = dismissingInteractiveAnimator
        dismissingInteractiveAnimator.presentingViewController = presentingViewController
        dismissingInteractiveAnimator.presentedViewController = presentedViewController
    }

    private weak var dismissingInteractiveAnimator: CardDismissingInteractiveAnimator?

    // MARK: - UI

    private var shade: CardShadeView!
    private var extender: CardScrollExtender!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var card: CardView!

    private func configureViews() {
        shade = CardShadeView()
        containerView?.addSubviews(shade)

        extender = CardScrollExtender()
        containerView?.addSubviews(extender)

        scrollView = UIScrollView()
        extender.link(scrollView)
        scrollView.clipsToBounds = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.decelerationRate = .fast
        extender.addSubviews(scrollView)

        contentView = UIView()
        scrollView.addSubview(contentView)

        card = CardView(
            style: cardStyle,
            cardDelegate: cardDelegate
        )
        contentView.addSubviews(card)

        subjectView?.translatesAutoresizingMaskIntoConstraints = false
        card.addSubviews(subjectView)
    }

    private func snapViews() {
        shade.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }

        extender.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(cardEdgeInset)
        }

        contentView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        card.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(scrollView)
        }

        subjectView?.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    // MARK: -

    private var cardStyle: CardView.Style {
        Device.current.hasSensorHousing ? .large : .default
    }

    private var subjectView: UIView? {
        presentedViewController.view
    }

    private var cardDelegate: CardViewControllerCompatible? {
        presentedViewController as? CardViewControllerCompatible
    }

    private func setPercentCompleteToShadeView(_ percentComplete: Double) {
        performAlongsideTransitionIfPossible { [weak self] in
            self?.shade.percentComplete = percentComplete
        }
    }

    private func performAlongsideTransitionIfPossible(_ block: @escaping Block) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else { return block() }

        coordinator.animate(
            alongsideTransition: { _ in
                block()
            },
            completion: nil
        )
    }

    // MARK: - Pre setup

    private func setupSelf() {
        configureViews()
        snapViews()
    }

    private func updateCardItemIfPossible() {
        if let viewController = presentedViewController as? ViewController {
            viewController.updateCardItem()
        }
        containerView?.layoutIfNeeded()
        scrollView.transform = CGAffineTransform(
            translationX: 0,
            y: scrollView.frame.height + cardEdgeInset
        )
    }

    private func setupInteractiveAnimatorBeforePresenting() {
        dismissingInteractiveAnimator?.scrollView = scrollView
        scrollView.delegate = dismissingInteractiveAnimator
    }

    // MARK: - UIPresentationController

    public override var presentedView: UIView? { scrollView }

    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        setupSelf()
        updateCardItemIfPossible()
        setupInteractiveAnimatorBeforePresenting()
        setPercentCompleteToShadeView(1)
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        setPercentCompleteToShadeView(0)
    }
}
