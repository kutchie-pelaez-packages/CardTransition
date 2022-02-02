import CardTransition
import CoreUI
import UIKit

final class PresentedViewController: ViewController, CardViewControllerCompatible {
    private var rectangle: UIView!
    private var leadingInsetIndicator: UIView!
    private var trailingInsetIndicator: UIView!
    private var topInsetIndicator: UIView!
    private var bottomInsetIndicator: UIView!

    override func configureViews() {
        view.backgroundColor = SystemColors.Background.primary

        rectangle = UIView()
        rectangle.backgroundColor = SystemColors.Tint.primary
        view.addSubviews(rectangle)

        leadingInsetIndicator = UIView()
        leadingInsetIndicator.backgroundColor = SystemColors.Tint.red
        view.addSubviews(leadingInsetIndicator)

        trailingInsetIndicator = UIView()
        trailingInsetIndicator.backgroundColor = SystemColors.Tint.red
        view.addSubviews(trailingInsetIndicator)

        topInsetIndicator = UIView()
        topInsetIndicator.backgroundColor = SystemColors.Tint.red
        view.addSubviews(topInsetIndicator)

        bottomInsetIndicator = UIView()
        bottomInsetIndicator.backgroundColor = SystemColors.Tint.red
        view.addSubviews(bottomInsetIndicator)
    }

    override func constraintViews() {
        rectangle.snp.makeConstraints { make in
            make.height.equalTo(100)
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

    // MARK: - CardViewControllerCompatible

    var cardCanCloseByButton: Bool { true }

    var cardCanCloseInteractive: Bool { true }

    func cardDidCloseByButton() {
        print("Will close by button")

        dismiss(animated: true) {
            print("Did close by button")
        }
    }

    func cardDidCloseInteractive() {
        print("Will close interactively")

        dismiss(animated: true) {
            print("Did close interactively")
        }
    }
}
