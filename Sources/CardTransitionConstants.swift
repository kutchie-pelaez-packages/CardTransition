import CoreUI
import Foundation
import UIKit

enum CardTransitionConstants {
    enum Timings {
        static let presenting: TimeInterval = .milliseconds(225)
        static let dismissing: TimeInterval = .milliseconds(200)
        static let returning: TimeInterval = .milliseconds(150)
    }

    enum Fonts {
        static let title = System.Fonts.largeTitle
    }

    enum Insets {
        static let titleWithCloseButton = UIEdgeInsets(
            top: 44,
            left: 16,
            bottom: 16,
            right: 24
        )
        static let titleWithoutCloseButton = UIEdgeInsets(
            top: 32,
            left: 16,
            bottom: 16,
            right: 16
        )
        static let closeButtonWithTitle = UIEdgeInsets(
            top: 12,
            right: 12
        )
        static let closeButtonWithoutTitle = UIEdgeInsets(
            top: 12,
            bottom: 16,
            right: 12
        )
    }

    enum Misc {
        static let cornerRadius: Double = 32
        static let velocityThreshold: Double = 300
        static let percentCompleteThreshold = 0.5
    }
}
