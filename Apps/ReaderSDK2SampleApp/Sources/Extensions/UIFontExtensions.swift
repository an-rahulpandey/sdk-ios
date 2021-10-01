//
//  UIFontExtensions.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 5/6/19.
//

import UIKit

extension UIFont {
    func fit(in size: CGSize, text: String, minimumSize: CGFloat? = nil) -> UIFont {
        var lowerBounds: CGFloat = 0
        var upperBounds: CGFloat = 1000 // Max font size

        var searching = true

        while searching {
            if upperBounds - lowerBounds < 1 {
                searching = false
            }

            let midPoint = (upperBounds - lowerBounds) / 2.0 + lowerBounds

            let midPointSizedFont = self.withSize(midPoint)
            let textSize = text.size(withAttributes: [NSAttributedString.Key.font: midPointSizedFont])

            if textSize.width < size.width && textSize.height < size.height {
                lowerBounds = midPoint
            } else {
                upperBounds = midPoint
            }
        }

        var fontSizeToUse: CGFloat {
            guard let minimumSize = minimumSize else {
                return lowerBounds
            }

            return lowerBounds < minimumSize ? minimumSize : lowerBounds
        }

        return self.withSize(fontSizeToUse)
    }
}
