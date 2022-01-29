import Combine
import Core
import CoreUI
import Foundation
import UIKit

public struct SheetItem: Reassignable {
    public var title: String?

    public mutating func updateCloseButtonVisibility() {
        reassign()
    }
}

extension UIView {
    fileprivate var sheetView: SheetView? {
        (self as? SheetView) ?? superview?.sheetView
    }
}

extension ViewController {
    private var sheetView: SheetView? {
        view.sheetView
    }

    public var sheetItem: SheetItem? {
        get {
            sheetView?.item
        } set {
            sheetView?.item = newValue
        }
    }

    @objc open func updateSheetItem() { }
}
