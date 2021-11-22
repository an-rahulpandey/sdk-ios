//
//  CartLineItemView.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/17/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class CartLineItemView: UIView {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var amountText: String? {
        didSet {
            amountLabel.text = amountText
        }
    }

    var font: UIFont? {
        didSet {
            titleLabel.font = font
            amountLabel.font = font
        }
    }

    var theme: Theme {
        didSet {
            titleLabel.textColor = theme.titleColor
            amountLabel.textColor = theme.titleColor
            backgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)
        }
    }

    private lazy var titleLabel = makeLabel()
    private lazy var amountLabel = makeLabel()

    init(theme: Theme) {
        self.theme = theme

        super.init(frame: .zero)

        titleLabel.textAlignment = .left
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amountLabel.textAlignment = .right
        amountLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        addSubview(titleLabel)
        addSubview(amountLabel)

        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: orderEntryDefaultMargin, bottom: 0, trailing: orderEntryDefaultMargin)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -orderEntryDefaultMargin),
            amountLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 52)
    }
}

private extension CartLineItemView {
    // MARK: - Factories

    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
