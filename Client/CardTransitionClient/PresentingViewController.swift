import CoreUI
import UIKit

final class PresentingViewController: ViewController {
    private let cardTransitioningDelegate = CardTransitioningDelegate()

    private func presentCard() {
        let viewController = PresentedViewController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = cardTransitioningDelegate

        print("Will present")

        present(viewController, animated: true) {
            print("Did present")
        }
    }

    // MARK: - UI

    private var presentButton: UIButton!

    override func configureViews() {
        view.backgroundColor = SystemColors.Background.primary

        presentButton = UIButton()
        presentButton.setTitle("Present", for: .normal)
        presentButton.setTitleColor(SystemColors.Tint.primary, for: .normal)
        presentButton.addAction { [weak self] in
            self?.presentCard()
        }
        view.addSubviews(presentButton)
    }

    override func constraintViews() {
        presentButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
