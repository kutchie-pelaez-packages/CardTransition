import Combine
import Core
import CoreUI
import Foundation
import UIKit

public struct CardItem: Reassignable {
    public var title: String?

    public mutating func updateCloseButtonVisibility() {
        reassign()
    }
}

extension UIView {
    fileprivate var cardView: CardView? {
        (self as? CardView) ?? superview?.cardView
    }
}

extension ViewController {
    private var cardView: CardView? {
        view.cardView
    }

    public var cardItem: CardItem? {
        get {
            cardView?.item
        } set {
            cardView?.item = newValue
        }
    }

    @objc open func updateCardItem() { }
}
