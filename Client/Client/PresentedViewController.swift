import CardTransition
import CoreUI
import Core
import UIKit

final class PresentedViewController: ViewController, CardPresentationControllerDelegate {
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
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }

        leadingInsetIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(rectangle)
            make.width.equalTo(32)
            make.height.equalTo(1)
        }

        trailingInsetIndicator.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(rectangle)
            make.width.equalTo(32)
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
            make.centerX.equalTo(rectangle)
            make.width.equalTo(1)
            make.height.equalTo(16)
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

    // MARK: - CardPresentationControllerDelegate

    func cardPresentationControllerTitle(_ cardPresentationController: CardPresentationController) -> String? {
        "Card Title"
    }

    func cardPresentationController(_ cardPresentationController: CardPresentationController, shouldDismissBy reason: CardDismissingReason) -> Bool {
        switch reason {
        case .closeButton:
            return true

        case .gesture:
            return true
        }
    }

    func cardPresentationController(_ cardPresentationController: CardPresentationController, didDismissBy reason: CardDismissingReason) {
        switch reason {
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
