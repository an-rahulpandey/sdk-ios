//
//  CartTableViewCell.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/14/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class CartTableViewCell: UITableViewCell, Themable {
    var lineItemFont: UIFont? {
        didSet {
            lineItemView.font = lineItemFont
        }
    }

    var theme: Theme = .init() {
        didSet {
            lineItemView.theme = theme
            backgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)
        }
    }

    lazy var lineItemView = makeLineItemView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(lineItemView)

        backgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)

        NSLayoutConstraint.activate([
            lineItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CartTableViewCell {
    // MARK: - Factories

    func makeLineItemView() -> CartLineItemView {
        let lineItemView = CartLineItemView(theme: theme)
        lineItemView.translatesAutoresizingMaskIntoConstraints = false
        return lineItemView
    }
}
