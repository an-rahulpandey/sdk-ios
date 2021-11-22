import UIKit

public enum ReaderSDK2UILayout {
    public static let tableViewCellMargin: CGFloat = 16
    public static let sectionSpacing: CGFloat = 32

    public static func preferredMargins(view: UIView) -> UIEdgeInsets {
        let preferredContentWidth = 0.915 * view.bounds.width
        let maximumContentWidth: CGFloat = 624.0
        let contentWidth = min(preferredContentWidth, maximumContentWidth)

        let horizontalMargin = ceil((view.bounds.width - contentWidth) / 2.0)

        return UIEdgeInsets(
            top: sectionSpacing,
            left: horizontalMargin,
            bottom: sectionSpacing,
            right: horizontalMargin
        )
    }
}
