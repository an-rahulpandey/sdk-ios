//
//  CartButton.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/21/19.
//

import ReaderSDK2
import UIKit

class CartButton: UIControl {
    var cart: Cart {
        didSet {
            reloadAppearance()
        }
    }

    private let theme: Theme

    private lazy var stackView = makeStackView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var itemCountLabel = makeItemCountLabel()

    init(theme: Theme, cart: Cart) {
        self.theme = theme
        self.cart = cart

        super.init(frame: .zero)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(itemCountLabel)

        setContentHuggingPriority(.required, for: .vertical)

        reloadAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override var intrinsicContentSize: CGSize {
        let height = max(titleLabel.intrinsicContentSize.height, itemCountLabel.intrinsicContentSize.height)
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.spacing = itemCountLabel.intrinsicContentSize.width * 0.25
    }
}

private extension CartButton {
    func reloadAppearance() {
        titleLabel.text = cart.items.isEmpty ? Strings.OrderEntry.noSaleTitle : Strings.OrderEntry.cartTitle

        itemCountLabel.isHidden = cart.items.isEmpty
        itemCountLabel.text = String(cart.items.count)
    }

    // MARK: - Factories

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = theme.titleColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .bold)

        return label
    }

    func makeItemCountLabel() -> UILabel {
        let label = ItemCountLabel(textColor: theme.buttonTextColor, backgroundColor: theme.tintColor)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false

        return stackView
    }
}

private class ItemCountLabel: UILabel {
    init(textColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)

        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.font = .systemFont(ofSize: 12, weight: .bold)
        self.textAlignment = .center
        self.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        // Set a static size so double digit items fit comfortably,
        // but the label doesn't alter its size as the item count changes.
        let templateString = NSAttributedString(
            string: "99", attributes: [NSAttributedString.Key.font: self.font!]
        )

        let padding: CGFloat = 3
        let preferredWidth = templateString.size().width + (padding * 2)
        let preferredHeight = templateString.size().width + (padding * 2)
        let sideLength = max(preferredWidth, preferredHeight)

        return CGSize(
            width: sideLength,
            height: sideLength
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = min(frame.height, frame.width) * 0.5
    }
}
