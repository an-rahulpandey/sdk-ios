//
//  KeypadEnteredPriceLabel.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 5/20/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class KeypadEnteredPriceLabel: UILabel {
    private let theme: Theme

    init(theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)

        textAlignment = .right

        // Uses an arbitrary size since the font will later be resized in drawText.
        font = UIFont.systemFont(ofSize: 1, weight: .bold)

        backgroundColor = ColorGenerator.secondaryBackgroundColor(theme: theme)

        setContentHuggingPriority(.required, for: .vertical)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UILabel

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets(for: rect))
        font = font.fit(in: insetRect.size, text: "0")

        super.drawText(in: insetRect)
    }
}

// MARK: - Private Methods
private extension KeypadEnteredPriceLabel {
    // MARK: - Layout

    func textInsets(for rect: CGRect) -> UIEdgeInsets {
        // Inset to height ratio.
        let verticalInsetRatioCompact: CGFloat = 0.1875

        let horizontalInsetRatioCompact: CGFloat = 0.25
        let horizontalInsetRatioRegular: CGFloat = 0.1333

        let bottomInsetRatioRegular: CGFloat = 0.1333
        let topInsetRatioRegular: CGFloat = 0.3333

        switch traitCollection.horizontalSizeClass {
        case .compact:
            let horizontalInset = rect.height * horizontalInsetRatioCompact
            let verticalInset = rect.height * verticalInsetRatioCompact

            return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        case .regular:
            let horizontalInset = rect.height * horizontalInsetRatioRegular
            let topInset = rect.height * topInsetRatioRegular
            let bottomInset = rect.height * bottomInsetRatioRegular

            return UIEdgeInsets(top: topInset, left: horizontalInset, bottom: bottomInset, right: horizontalInset)
        case .unspecified:
            return UIEdgeInsets.zero
        @unknown default:
            fatalError("Unexpected size class.")
        }
    }
}
