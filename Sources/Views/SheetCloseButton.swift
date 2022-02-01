import CoreUI
import UIKit

private let verticalContentInsets: Double = 11.5
private let horizontalContentInsets: Double = 8.5

private enum Symbols: Symbol {
    case xmarkCircleFill
}

final class SheetCloseButton: Button {
    init(style: SheetView.Style) {
        self.style = style
        super.init()
    }

    private let style: SheetView.Style

    // MARK: - UI

    override func makeConfiguration() -> UIButton.Configuration? {
        var configuration = Configuration.plain()
        configuration.image = Symbols.xmarkCircleFill
            .font(SystemFonts.medium(17.5))
            .palette(
                primary: UIColor(light: 0x47474DA3, dark: 0xE8E8F2B0),
                secondary: UIColor(light: 0x73737B1F, dark: 0x75757D3D)
            )
            .image
        configuration.contentInsets = NSDirectionalEdgeInsets(
            horizontal: horizontalContentInsets,
            vertical: verticalContentInsets
        )

        return configuration
    }

    override var isHighlighted: Bool {
        didSet {
            animation(duration: 0.25) {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }
        }
    }
}
