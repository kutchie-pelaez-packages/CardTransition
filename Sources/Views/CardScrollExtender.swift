import CoreUI
import UIKit

public final class CardScrollExtender: View {
    private weak var scrollView: UIScrollView?

    public func link(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard
            let scrollView = scrollView,
            let contentView = scrollView.subviews.last,
            let card = contentView.subviews.first
        else {
            return super.hitTest(
                point,
                with: event
            )
        }

        let contertedCardFrame = contentView.convert(card.frame, to: self)
        let isInCard = contertedCardFrame.contains(point)
        let isInScrollView = scrollView.frame.contains(point)

        if
            isInCard &&
            isInScrollView
        {
            return super.hitTest(
                point,
                with: event
            )
        } else if isInCard {
            return scrollView
        } else if isInScrollView {
            return nil
        } else {
            return super.hitTest(
                point,
                with: event
            )
        }
    }
}
