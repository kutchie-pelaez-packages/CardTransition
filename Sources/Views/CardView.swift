import Core
import CoreUI
import SnapKit
import UIKit

final class CardView: View {
    private enum ContentType {
        case titleWithCloseButton
        case onlyTitle
        case onlyCloseButton
        case none
    }

    init(
        presentationController: CardPresentationController,
        dataSource: CardPresentationControllerDataSource?,
        delegate: CardPresentationControllerDelegate?
    ) {
        self.presentationController = presentationController
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
    }

    private unowned let presentationController: CardPresentationController
    private unowned let dataSource: CardPresentationControllerDataSource?
    private unowned let delegate: CardPresentationControllerDelegate?

    private var title: String? { dataSource?.title(for: presentationController) }
    private var hasTitle: Bool { title.isNotNil }

    private var canCloseByButton: Bool {
        delegate?.cardPresentationController(
            presentationController,
            shouldDismissBy: .closeButton
        ) == true
    }

    private var contentType: ContentType {
        if hasTitle && canCloseByButton {
            return .titleWithCloseButton
        } else if hasTitle {
            return .onlyTitle
        } else if canCloseByButton {
            return .onlyCloseButton
        } else {
            return .none
        }
    }

    // MARK: - UI

    private var backgroundView: UIView!
    private var contentView: UIView!
    private var titleLabel: UILabel!
    private var closeButton: UIButton!

    override func configureViews() {
        backgroundView = UIView()
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = CardTransitionConstants.Misc.cornerRadius
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundView.backgroundColor = UIColor(
            light: System.Colors.Background.primary.light.hex,
            dark: System.Colors.Background.secondary.dark.hex
        )
        super.addSubview(backgroundView)

        contentView = UIView()
        super.addSubview(contentView)

        contentView = UIView()
        super.addSubview(contentView)

        titleLabel = UILabel(
            font: System.Fonts.bold(30),
            textColor: System.Colors.Label.primary,
            numberOfLines: 0,
            textAlignment: .natural
        )
        titleLabel.text = title
        titleLabel.isVisible = hasTitle
        super.addSubview(titleLabel)

        closeButton = System.CloseButton()
        closeButton.addAction { [weak self] in
            guard let presentationController = self?.presentationController else { return }

            self?.delegate?.cardPresentationController(
                presentationController,
                didDismissBy: .closeButton
            )
        }
        closeButton.isVisible = canCloseByButton
        super.addSubview(closeButton)
    }

    override func constraintViews() {
        switch contentType {
        case .titleWithCloseButton:
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(CardTransitionConstants.Insets.titleWithCloseButton.left)
                make.top.equalToSuperview().inset(CardTransitionConstants.Insets.titleWithCloseButton.top)
            }

            closeButton.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(CardTransitionConstants.Insets.closeButtonWithTitle.top)
                make.trailing.equalToSuperview().inset(CardTransitionConstants.Insets.closeButtonWithTitle.right)
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).inset(-CardTransitionConstants.Insets.titleWithCloseButton.right)
            }

            contentView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).inset(-CardTransitionConstants.Insets.titleWithCloseButton.bottom)
            }

        case .onlyTitle:
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(CardTransitionConstants.Insets.titleWithoutCloseButton.left)
                make.trailing.equalToSuperview().inset(CardTransitionConstants.Insets.titleWithoutCloseButton.right)
                make.top.equalToSuperview().inset(CardTransitionConstants.Insets.titleWithoutCloseButton.top)
            }

            contentView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).inset(-CardTransitionConstants.Insets.titleWithoutCloseButton.bottom)
            }

        case .onlyCloseButton:
            closeButton.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(CardTransitionConstants.Insets.closeButtonWithoutTitle.top)
                make.trailing.equalToSuperview().inset(CardTransitionConstants.Insets.closeButtonWithoutTitle.right)
            }

            contentView.snp.remakeConstraints { make in
                make.directionalEdges.equalToSuperview()
            }

        case .none:
            contentView.snp.remakeConstraints { make in
                make.directionalEdges.equalToSuperview()
            }
        }

        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView).inset(-1000)
        }
    }

    // MARK: - UIView

    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
}
