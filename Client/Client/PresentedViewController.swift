import CardTransition
import CoreUI
import Core
import UIKit

final class PresentedViewController:
    ViewController,
    CardPresentationControllerDataSource,
    CardPresentationControllerDelegate
{
    private var rectangle: UIView!
    private var leadingInsetIndicator: UIView!
    private var trailingInsetIndicator: UIView!
    private var topInsetIndicator: UIView!
    private var bottomInsetIndicator: UIView!

    override func configureViews() {
        rectangle = UIView()
        rectangle.backgroundColor = System.Colors.Tint.primary
        view.addSubviews(rectangle)

        leadingInsetIndicator = UIView()
        leadingInsetIndicator.backgroundColor = System.Colors.Tint.red
        view.addSubviews(leadingInsetIndicator)

        trailingInsetIndicator = UIView()
        trailingInsetIndicator.backgroundColor = System.Colors.Tint.red
        view.addSubviews(trailingInsetIndicator)

        topInsetIndicator = UIView()
        topInsetIndicator.backgroundColor = System.Colors.Tint.red
        view.addSubviews(topInsetIndicator)

        bottomInsetIndicator = UIView()
        bottomInsetIndicator.backgroundColor = System.Colors.Tint.red
        view.addSubviews(bottomInsetIndicator)
    }

    override func constraintViews() {
        rectangle.snp.makeConstraints { make in
            make.height.equalTo(rectangle.snp.width)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        leadingInsetIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(rectangle)
            make.width.equalTo(16)
            make.height.equalTo(1)
        }

        trailingInsetIndicator.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(rectangle)
            make.width.equalTo(16)
            make.height.equalTo(1)
        }

        topInsetIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(rectangle)
            make.width.equalTo(1)
            make.height.equalTo(16)
        }

        bottomInsetIndicator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.centerX.equalTo(rectangle)
            make.width.equalTo(1)
        }
    }

    override func viewDidLayout() {
        assert(
            !rectangle.frame.intersects(leadingInsetIndicator.frame) &&
            !rectangle.frame.intersects(trailingInsetIndicator.frame) &&
            !rectangle.frame.intersects(topInsetIndicator.frame) &&
            !rectangle.frame.intersects(bottomInsetIndicator.frame)
        )
    }

    // MARK: - CardPresentationControllerDataSource

    func title(for cardPresentationController: CardPresentationController) -> String? {
        "Card Title"
    }

    // MARK: - CardPresentationControllerDelegate

    func cardPresentationController(_ cardPresentationController: CardPresentationController, shouldDismissBy dismissingReason: CardDismissingReason) -> Bool {
        switch dismissingReason {
        case .closeButton:
            return true

        case .gesture:
            return true
        }
    }

    func cardPresentationController(_ cardPresentationController: CardPresentationController, didDismissBy dismissingReason: CardDismissingReason) {
        switch dismissingReason {
        case .closeButton:
            print("Will close by button")

            dismiss(animated: true) {
                print("Did close by button")
            }

        case .gesture:
            print("Will close by gesture")

            dismiss(animated: true) {
                print("Did close by gesture")
            }
        }
    }
}
