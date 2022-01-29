import Core
import CoreUI
import UIKit

final class SheetShadeView: View {
    @Clamped(0...1)
    var percentComplete: Double = 0 {
        didSet {
            update(for: percentComplete)
        }
    }

    private func update(for percentComplete: Double) {
        alpha = percentComplete
    }

    // MARK: - UI

    override func configureViews() {
        backgroundColor = .black.withAlphaComponent(0.6)
        update(for: percentComplete)
    }
}
