import Core
import CoreUI
import DeviceKit
import UIKit

let sheetEdgeInset: Double = 6

public final class SheetPresentationController: UIPresentationController {
    public func link(_ dismissingInteractiveAnimator: SheetDismissingInteractiveAnimator) {
        self.dismissingInteractiveAnimator = dismissingInteractiveAnimator
        dismissingInteractiveAnimator.presentingViewController = presentingViewController
        dismissingInteractiveAnimator.presentedViewController = presentedViewController
    }

    private weak var dismissingInteractiveAnimator: SheetDismissingInteractiveAnimator?

    // MARK: - UI

    private var shade: SheetShadeView!
    private var extender: SheetScrollExtender!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var sheet: SheetView!

    private func configureViews() {
        shade = SheetShadeView()
        containerView?.addSubviews(shade)

        extender = SheetScrollExtender()
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

        sheet = SheetView(
            style: sheetStyle,
            sheetDelegate: sheetDelegate
        )
        contentView.addSubviews(sheet)

        subjectView?.translatesAutoresizingMaskIntoConstraints = false
        sheet.addSubviews(subjectView)
    }

    private func snapViews() {
        shade.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }

        extender.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(sheetEdgeInset)
        }

        contentView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        sheet.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(scrollView)
        }

        subjectView?.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    // MARK: -

    private var sheetStyle: SheetView.Style {
        Device.current.hasSensorHousing ? .large : .default
    }

    private var subjectView: UIView? {
        presentedViewController.view
    }

    private var sheetDelegate: SheetViewControllerCompatible? {
        presentedViewController as? SheetViewControllerCompatible
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

    private func updateSheetItemIfPossible() {
        if let viewController = presentedViewController as? ViewController {
            viewController.updateSheetItem()
        }
        containerView?.layoutIfNeeded()
        scrollView.transform = CGAffineTransform(
            translationX: 0,
            y: scrollView.frame.height + sheetEdgeInset
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
        updateSheetItemIfPossible()
        setupInteractiveAnimatorBeforePresenting()
        setPercentCompleteToShadeView(1)
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        setPercentCompleteToShadeView(0)
    }
}
