import Core
import CoreUI
import DeviceKit
import SnapKit
import UIKit

private let titleLeadingInset: Double = 36
private let titleTopInset: Double = 28
private let labelToCloseButtonInset: Double = 8
private let labelToContentViewInset: Double = 8

private func closeButtonEdgeInset(for style: CardView.Style) -> Double {
    switch style {
    case .default:
        return 2

    case .large:
        return 10
    }
}

final class CardView: View {
    enum Style {
        case `default`
        case large
    }

    init(
        style: Style,
        presentationController: CardPresentationController?,
        cardPresentationControllerDelegate: CardPresentationControllerDelegate?
    ) {
        self.style = style
        self.presentationController = presentationController
        self.cardPresentationControllerDelegate = cardPresentationControllerDelegate
        super.init()
    }

    private let style: Style
    private weak var presentationController: CardPresentationController?
    private weak var cardPresentationControllerDelegate: CardPresentationControllerDelegate?

    // MARK: - UI

    private var titleLabel: UILabel!
    private var closeButton: UIButton!
    private var contentView: UIView!
    private var contentTopConstraint: Constraint?

    override func configureViews() {
        clipsToBounds = true
        backgroundColor = UIColor(
            light: System.Colors.Background.primary.light.hex,
            dark: System.Colors.Background.secondary.dark.hex
        )
        #warning("Apply different cornerRadius based on device")
        layer.cornerRadius = Device.current.cornerRadius.clamped(13...)

        titleLabel = UILabel(
            font: System.Fonts.bold(30),
            textColor: System.Colors.Label.primary,
            numberOfLines: 0,
            textAlignment: .natural
        )
        super.addSubview(titleLabel)

        closeButton = CardCloseButton(style: style)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.addAction { [weak self] in
            guard let presentationController = self?.presentationController else { return }

            self?.cardPresentationControllerDelegate?.cardPresentationController(
                presentationController,
                didDismissBy: .closeButton
            )
        }
        super.addSubview(closeButton)

        contentView = UIView()
        super.addSubview(contentView)

        setCardContent()
    }

    private func setCardContent() {
        guard let presentationController = presentationController else { return }

        let title = cardPresentationControllerDelegate?.cardPresentationControllerTitle(presentationController)
        titleLabel.text = title
        titleLabel.isVisible = title.isNotNil

        closeButton.isVisible = cardPresentationControllerDelegate?.cardPresentationController(
            presentationController,
            shouldDismissBy: .closeButton
        ) == true
    }

    override func constraintViews() {
        contentTopConstraint?.deactivate()

        if
            let presentationController = presentationController,
            cardPresentationControllerDelegate?.cardPresentationController(
                presentationController,
                shouldDismissBy: .closeButton
            ) == true &&
            cardPresentationControllerDelegate?.cardPresentationControllerTitle(
                presentationController
            ).isNotNil == true
        {
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(titleLeadingInset)
                make.top.equalToSuperview().inset(titleTopInset)
            }

            closeButton.snp.remakeConstraints { make in
                make.top.trailing.equalToSuperview().inset(closeButtonEdgeInset(for: style))
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).inset(-labelToCloseButtonInset)
            }

            contentView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                contentTopConstraint = make.top.equalTo(titleLabel.snp.bottom).inset(-labelToContentViewInset).constraint
            }
        } else if
            let presentationController = presentationController,
            cardPresentationControllerDelegate?.cardPresentationControllerTitle(
                presentationController
            ).isNotNil == true
        {
            titleLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(titleLeadingInset)
                make.top.equalToSuperview().inset(titleTopInset)
            }

            contentView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                contentTopConstraint = make.top.equalTo(titleLabel.snp.bottom).inset(-labelToContentViewInset).constraint
            }
        } else {
            closeButton.snp.remakeConstraints { make in
                make.top.trailing.equalToSuperview().inset(closeButtonEdgeInset(for: style))
            }

            contentView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                contentTopConstraint = make.top.equalToSuperview().constraint
            }
        }
    }

    // MARK: - UIView

    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
}
