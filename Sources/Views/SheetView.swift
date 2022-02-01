import Core
import CoreUI
import DeviceKit
import SnapKit
import UIKit

private let titleLeadingInset: Double = 36
private let titleTopInset: Double = 28
private let labelToCloseButtonInset: Double = 8
private let labelToContentViewInset: Double = 8

private func closeButtonEdgeInset(for style: SheetView.Style) -> Double {
    switch style {
    case .default:
        return 2

    case .large:
        return 10
    }
}

final class SheetView: View {
    enum Style {
        case `default`
        case large
    }

    init(
        style: Style,
        sheetDelegate: SheetViewControllerCompatible?
    ) {
        self.style = style
        self.sheetDelegate = sheetDelegate
        super.init()
    }

    private let style: Style
    private weak var sheetDelegate: SheetViewControllerCompatible?

    private var contentTopConstraint: Constraint?

    var item: SheetItem! {
        didSet {
            itemDidUpdate()
        }
    }

    // MARK: - UI

    private var titleLabel: UILabel!
    private var closeButton: UIButton!
    private var contentView: UIView!

    override func configureViews() {
        clipsToBounds = true
        backgroundColor = UIColor(
            light: SystemColors.Background.secondary.light,
            dark: SystemColors.Background.tertiary.dark
        )
        #warning("Apply different cornerRadius based on device")
        layer.cornerRadius = Device.current.cornerRadius
            .clamped(13...)

        titleLabel = UILabel(
            font: SystemFonts.bold(30),
            textColor: SystemColors.Label.primary,
            numberOfLines: 0,
            textAlignment: .natural
        )
        super.addSubview(titleLabel)

        closeButton = SheetCloseButton(style: style)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.addAction { [weak self] in
            self?.sheetDelegate?.sheetDidCloseByButton()
        }
        super.addSubview(closeButton)

        contentView = UIView()
        super.addSubview(contentView)

        item = SheetItem()
    }

    override func constraintViews() {
        contentTopConstraint?.deactivate()

        if
            item.title != nil &&
            sheetDelegate?.sheetCanCloseByButton == true
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
        } else if item.title != nil {
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

    // MARK: - Item updating

    private func itemDidUpdate() {
        titleLabel.text = item.title
        titleLabel.isVisible = item.title != nil

        closeButton.isVisible = sheetDelegate?.sheetCanCloseByButton == true

        setNeedsUpdateConstraints()
    }
}
