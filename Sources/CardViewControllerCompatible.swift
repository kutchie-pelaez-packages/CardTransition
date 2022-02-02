public protocol CardViewControllerCompatible: AnyObject {
    var cardCanCloseByButton: Bool { get }
    var cardCanCloseInteractive: Bool { get }
    func cardDidCloseByButton()
    func cardDidCloseInteractive()
}

extension CardViewControllerCompatible {
    public var cardCanCloseByButton: Bool { false }
    public var cardCanCloseInteractive: Bool { false }
    public func cardDidCloseByButton() { }
    public func cardDidCloseInteractive() { }
}
