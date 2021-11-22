//
//  KeypadButton.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 5/3/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

protocol KeypadButtonDelegate: AnyObject {
    func didTapKeypadButton(value: KeypadButton.Value)
}

class KeypadButton: UIButton {
    enum Value: CustomStringConvertible, Equatable {
        case digit(Int)
        case clear
        case addItem

        var description: String {
            switch self {
            case .digit(let digit):
                return String(digit)
            case .clear:
                return Strings.OrderEntry.clearAmountKeypadButton
            case .addItem:
                // Fullwidth plus sign (U+FF0B) aligns better vertically than "+"
                return "＋"
            }
        }

        static func == (lhs: Value, rhs: Value) -> Bool {
            switch (lhs, rhs) {
            case (.digit(let lhsDigit), .digit(let rhsDigit)):
                return lhsDigit == rhsDigit
            case (.addItem, .addItem), (.clear, .clear):
                return true
            case (.addItem, _), (.clear, _), (.digit, _):
                return false
            }
        }
    }

    let value: Value
    private let theme: Theme
    weak var delegate: KeypadButtonDelegate?

    override var isHighlighted: Bool {
        didSet {
            let tertiaryBackgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)
            let highlightedBackgroundColor = ColorGenerator.highlighted(color: tertiaryBackgroundColor)

            backgroundColor = isHighlighted ? highlightedBackgroundColor : tertiaryBackgroundColor
        }
    }

    init(theme: Theme, value: Value) {
        self.value = value
        self.theme = theme
        super.init(frame: .zero)

        setTitle(value.description, for: .normal)

        // Uses an arbitrary size since the font will later be resized in layoutSubviews.
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 1)

        let titleColor = value == .addItem ? theme.tintColor : theme.titleColor
        setTitleColor(titleColor, for: .normal)

        backgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)

        layer.borderColor = ColorGenerator.borderColor(theme: theme).cgColor
        layer.borderWidth = 0.5

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let textFrame = CGSize(width: frame.width, height: frame.height * 0.25)

        // "W" is usually one of the widest and tallest letters in any font.
        titleLabel?.font = titleLabel?.font.fit(in: textFrame, text: "W")
    }
}

// MARK: - Private Methods
private extension KeypadButton {
    // MARK: - Actions

    @objc func didTap() {
        delegate?.didTapKeypadButton(value: value)
    }
}
