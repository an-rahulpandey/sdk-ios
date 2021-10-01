//
//  ChargeButton.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/10/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class ChargeButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            didChangeButtonState()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            didChangeButtonState()
        }
    }

    var cartTotal: Money {
        didSet {
            reloadAppearance()
        }
    }

    private let theme: Theme

    private var minimumDimension: CGFloat {
        return min(frame.width, frame.height)
    }

    private var title: String {
        if cartTotal.amount > 0 {
            return "\(Strings.OrderEntry.chargeButtonTitle) \(cartTotal.description)"
        }
        return Strings.OrderEntry.chargeButtonTitle
    }

    init(theme: Theme, cartTotal: Money) {
        self.theme = theme
        self.cartTotal = cartTotal

        super.init(frame: .zero)

        // Uses an arbitrary size since the font will later be resized in layoutSubviews.
        titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)

        setContentHuggingPriority(.required, for: .vertical)

        reloadAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = minimumDimension * 0.125
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 64)
    }
}

private extension ChargeButton {
    // MARK: - Reload UI

    private func reloadAppearance() {
        setTitle(title, for: .normal)
        isEnabled = cartTotal.amount > 0
    }

    private func didChangeButtonState() {
        let shadowRadius = minimumDimension * 0.05
        layer.shadowOffset = CGSize(width: 0, height: shadowRadius * 0.5)

        layer.shadowRadius = shadowRadius

        if isHighlighted {
            backgroundColor = ColorGenerator.highlighted(color: theme.tintColor)
            layer.shadowOpacity = 0.1
        } else if isEnabled {
            backgroundColor = theme.tintColor
            layer.shadowOpacity = 0.2
        } else {
            backgroundColor = ColorGenerator.disabled(color: theme.tintColor)
            layer.shadowOpacity = 0
        }
    }
}
