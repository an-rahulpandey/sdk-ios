//
//  CustomAmountEntryView.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/7/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class CustomAmountEntryView: UIView {
    var openItem: Cart.Item? {
        didSet {
            updateEnteredPriceLabel()
            cartUpdateDelegate?.didUpdate(openItem: openItem)
        }
    }

    private var enteredPriceLabelHeightConstraint: NSLayoutConstraint?

    private var openItemPrice: Money {
        if let openItem = openItem {
            return openItem.price
        } else {
            return Money(amount: 0, currency: currency)
        }
    }

    weak var cartUpdateDelegate: CartUpdateDelegate?

    private var currency: Currency
    private let theme: Theme

    private lazy var containerStackView = makeContainerStackView()
    private lazy var enteredPriceLabel = makeEnteredPriceLabel()
    private lazy var keypadView = makeKeypadView()

    init(theme: Theme, openItem: Cart.Item?, currency: Currency) {
        self.theme = theme
        self.openItem = openItem
        self.currency = currency

        super.init(frame: .zero)

        addSubview(containerStackView)
        containerStackView.addArrangedSubview(enteredPriceLabel)
        containerStackView.addArrangedSubview(HairlineView(theme: theme))
        containerStackView.addArrangedSubview(keypadView)

        applyConstraints()
        updateEnteredPriceLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
}

// MARK: - KeypadButtonDelegate
extension CustomAmountEntryView: KeypadButtonDelegate {
    func didTapKeypadButton(value: KeypadButton.Value) {
        switch value {
        case .digit(let digit):
            guard let newAmount = UInt("\(openItemPrice.amount)\(digit)") else {
                return
            }

            if newAmount != 0 {
                let newPrice = Money(amount: newAmount, currency: currency)
                openItem = Cart.Item(customPrice: newPrice)
            }
        case .clear:
            resetEnteredPrice()
        case .addItem:
            closeOpenItem()
        }
    }

    @objc func resetEnteredPrice() {
        openItem = nil
    }

    @objc private func closeOpenItem() {
        guard openItem != nil else {
            return
        }

        cartUpdateDelegate?.closeOpenItem()
        resetEnteredPrice()
    }
}

// MARK: - UIKeyInput
extension CustomAmountEntryView: UIKeyInput {
    var hasText: Bool {
        return openItem != nil
    }

    func insertText(_ text: String) {
        switch text {
        case "0"..."9":
            let digit = Int(text)!
            didTapKeypadButton(value: .digit(digit))
        case "\n":
            didTapKeypadButton(value: .addItem)
        default:
            ()
        }
    }

    func deleteBackward() {
        var amountString = String(openItemPrice.amount)
        amountString.removeLast()

        if amountString.count == 0 {
            openItem = nil
        } else {
            let newPrice = Money(amount: UInt(amountString)!, currency: currency)
            openItem = Cart.Item(customPrice: newPrice)
        }
    }

    override var inputView: UIView? {
        // Return a dummy view to prevent the system keyboard from appearing
        return UIView()
    }

    override var keyCommands: [UIKeyCommand]? {
        return [
            // Cmd + Backspace
            UIKeyCommand(
                input: "\u{8}",
                modifierFlags: .command,
                action: #selector(resetEnteredPrice),
                discoverabilityTitle: Strings.OrderEntry.clearAmountKeyboardShortcutName
            ),
        ]
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updatePriceLabel(for: traitCollection)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updatePriceLabel(for: traitCollection)
    }
}

// MARK: - Helpers
private extension CustomAmountEntryView {

    // MARK: - Update UI

    func updateEnteredPriceLabel() {
        let isCartEmpty: Bool = openItem?.price.amount == nil
        enteredPriceLabel.textColor = isCartEmpty ? ColorGenerator.disabled(color: theme.titleColor) : theme.titleColor
        enteredPriceLabel.text = openItemPrice.description
    }

    // MARK: - Layout

    func applyConstraints() {
        containerStackView.pinToEdges(of: safeAreaLayoutGuide)

        updatePriceLabel(for: traitCollection)
    }

    private func updatePriceLabel(for traitCollection: UITraitCollection) {
        let validSizeClasses: [UIUserInterfaceSizeClass] = [.compact, .regular]

        guard validSizeClasses.contains(traitCollection.horizontalSizeClass) else {
            return
        }

        let enteredPriceLabelHeightToViewHeightRatio: CGFloat = {
            switch traitCollection.horizontalSizeClass {
            case .compact:
                return 0.12
            case .regular:
                return 0.25
            case .unspecified:
                return 0
            @unknown default:
                return 0
            }
        }()

        enteredPriceLabelHeightConstraint?.isActive = false
        enteredPriceLabelHeightConstraint = enteredPriceLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: enteredPriceLabelHeightToViewHeightRatio)
        enteredPriceLabelHeightConstraint?.isActive = true
    }

    // MARK: - Factories

    func makeEnteredPriceLabel() -> KeypadEnteredPriceLabel {
        let label = KeypadEnteredPriceLabel(theme: theme)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func makeKeypadView() -> KeypadView {
        let keypadView = KeypadView(theme: theme, buttonDelegate: self)
        keypadView.translatesAutoresizingMaskIntoConstraints = false
        return keypadView
    }

    func makeContainerStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }
}
