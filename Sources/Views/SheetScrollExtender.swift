import CoreUI
import UIKit

public final class SheetScrollExtender: View {
    private weak var scrollView: UIScrollView?

    public func link(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard
            let scrollView = scrollView,
            let contentView = scrollView.subviews.last,
            let sheet = contentView.subviews.first
        else {
            return super.hitTest(
                point,
                with: event
            )
        }

        let contertedSheetFrame = contentView.convert(sheet.frame, to: self)
        let isInSheet = contertedSheetFrame.contains(point)
        let isInScrollView = scrollView.frame.contains(point)

        if
            isInSheet &&
            isInScrollView
        {
            return super.hitTest(
                point,
                with: event
            )
        } else if isInSheet {
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
