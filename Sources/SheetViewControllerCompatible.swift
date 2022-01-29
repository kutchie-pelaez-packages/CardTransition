public protocol SheetViewControllerCompatible: AnyObject {
    var sheetCanCloseByButton: Bool { get }
    var sheetCanCloseInteractive: Bool { get }
    func sheetDidCloseByButton()
    func sheetDidCloseInteractive()
}

extension SheetViewControllerCompatible {
    public var sheetCanCloseByButton: Bool { false }
    public var sheetCanCloseInteractive: Bool { false }
    public func sheetDidCloseByButton() { }
    public func sheetDidCloseInteractive() { }
}
