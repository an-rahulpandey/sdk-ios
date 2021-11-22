//
//  Button.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/14/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

final class Button: UIButton {
    enum Style {
        case prominent, outline
    }

    var style: Style = .prominent {
        didSet {
            reloadAppearance()
        }
    }

    private var theme: Theme = .init()

    convenience init(theme: Theme) {
        self.init(theme: theme, style: .prominent)
    }

    convenience init(theme: Theme, style: Style = .prominent) {
        self.init(type: .system)

        self.theme = theme
        self.style = style

        titleLabel?.font = .systemFont(ofSize: 20, weight: .black)
        layer.cornerRadius = 8
        reloadAppearance()
    }

    override var isEnabled: Bool {
        didSet {
            reloadAppearance()
        }
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 64
        return size
    }

    func reloadAppearance() {
        switch style {
        case .prominent: reloadProminentAppearance()
        case .outline: reloadOutlineAppearance()
        }
    }

    func reloadProminentAppearance() {
        setTitleColor(theme.buttonTextColor, for: [])
        backgroundColor = isEnabled ? theme.tintColor : ColorGenerator.disabled(color: theme.tintColor)

        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = isEnabled ? 0.25 : 0.0

        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }

    func reloadOutlineAppearance() {
        setTitleColor(isEnabled ? theme.tintColor : ColorGenerator.disabled(color: theme.tintColor), for: [])
        backgroundColor = .clear

        layer.shadowRadius = 0
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0

        layer.borderColor = theme.tintColor.cgColor
        layer.borderWidth = 1
    }
}
