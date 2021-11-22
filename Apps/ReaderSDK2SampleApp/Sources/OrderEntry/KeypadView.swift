//
//  KeypadView.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 5/3/19.
//

import ReaderSDK2
import UIKit

class KeypadView: UIStackView {
    private let theme: Theme

    init(theme: Theme, buttonDelegate: KeypadButtonDelegate) {
        self.theme = theme
        super.init(frame: .zero)

        axis = .vertical
        distribution = .fillEqually
        spacing = 0

        for buttonRow in makeButtonRows(buttonDelegate: buttonDelegate) {
            addArrangedSubview(buttonRow)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension KeypadView {
    // MARK: - View factories

    func makeButtonRows(buttonDelegate: KeypadButtonDelegate) -> [UIStackView] {
        let buttonValueRows: [[KeypadButton.Value]] = [
            [.digit(1), .digit(2), .digit(3)],
            [.digit(4), .digit(5), .digit(6)],
            [.digit(7), .digit(8), .digit(9)],
            [.clear, .digit(0), .addItem],
        ]

        var buttonRows = [UIStackView]()

        for rowOfValues in buttonValueRows {
            buttonRows.append(makeStackView(from: rowOfValues, buttonDelegate: buttonDelegate))
        }

        return buttonRows
    }

    func makeStackView(from rowOfValues: [KeypadButton.Value], buttonDelegate: KeypadButtonDelegate?) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0

        for value in rowOfValues {
            let button = KeypadButton(theme: theme, value: value)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.delegate = buttonDelegate
            stackView.addArrangedSubview(button)
        }

        return stackView
    }
}
