//
//  ConfigExtensions.swift
//  ReaderSDK2
//
//  Created by Mike Silvis on 3/11/20.
//  Copyright © 2020 Square, Inc. All rights reserved.
//

import ReaderSDK2

extension Config {
    static var theme: Theme {
        get {
            var option: Theme.Option {
                guard let rawValue = UserDefaults.standard.string(forKey: "ReaderSDK-Sample-Theme") else {
                    return Theme.Option.standard
                }

                return Theme.Option(rawValue: rawValue) ?? Theme.Option.standard
            }

            return option.theme
        }
        set {
            var option: Theme.Option {
                let updatedTheme = Theme.Option.allCases.first { (option) -> Bool in
                    return option.theme == newValue
                }

                return updatedTheme ?? Theme.Option.standard
            }

            UserDefaults.standard.set(option.rawValue, forKey: "ReaderSDK-Sample-Theme")
        }
    }

    static var parameters = PaymentParameters(amountMoney: Money(amount: 0, currency: .USD))
}

extension Theme {
    enum Option: String, CustomStringConvertible, CaseIterable, Equatable {
        case standard = "Standard"
        case shakeShack = "Burger"
        case warriors = "Basketball"

        var description: String {
            return rawValue
        }

        var theme: Theme {
            switch self {
            case .standard:
                return Theme()
            case .shakeShack:
                return Theme(
                    titleColor: .white,
                    titleFont: .systemFont(ofSize: 24, weight: .black),
                    subtitleColor: .white,
                    subtitleFont: .systemFont(ofSize: 16, weight: .medium),
                    tintColor: #colorLiteral(red: 0.3843137255, green: 0.6745098039, blue: 0.2078431373, alpha: 1),
                    backgroundColor: .black,
                    buttonTextColor: .white,
                    buttonFont: .systemFont(ofSize: 32, weight: .black),
                    buttonCornerRadius: 8,
                    informationIconColor: #colorLiteral(red: 0.3843137255, green: 0.6745098039, blue: 0.2078431373, alpha: 1),
                    successIconColor: #colorLiteral(red: 0.3843137255, green: 0.6745098039, blue: 0.2078431373, alpha: 1),
                    errorIconColor: #colorLiteral(red: 0.8431372549, green: 0.1803921569, blue: 0.1960784314, alpha: 1),
                    cornerRadius: 0,
                    presentationStyle: .alwaysFullscreen,
                    inputFieldColor: .black,
                    inputFieldTextColor: .white,
                    inputFieldPlaceholderTextColor: .white,
                    inputFieldErrorColor: #colorLiteral(red: 0.8431372549, green: 0.1803921569, blue: 0.1960784314, alpha: 1)
                )
            case .warriors:
                return Theme(
                    titleColor: .white,
                    titleFont: .systemFont(ofSize: 24, weight: .black),
                    subtitleColor: .white,
                    subtitleFont: .systemFont(ofSize: 16, weight: .medium),
                    tintColor: #colorLiteral(red: 1, green: 0.7788988948, blue: 0.1741508245, alpha: 1),
                    backgroundColor: #colorLiteral(red: 0.1154184118, green: 0.2600637376, blue: 0.5409679413, alpha: 1),
                    buttonTextColor: .white,
                    buttonFont: .systemFont(ofSize: 32, weight: .black),
                    buttonCornerRadius: 8,
                    informationIconColor: .white,
                    successIconColor: #colorLiteral(red: 1, green: 0.7788988948, blue: 0.1741508245, alpha: 1),
                    errorIconColor: #colorLiteral(red: 1, green: 0.7788988948, blue: 0.1741508245, alpha: 1),
                    cornerRadius: 0,
                    presentationStyle: .alwaysFullscreen,
                    inputFieldColor: #colorLiteral(red: 0.1154184118, green: 0.2600637376, blue: 0.5409679413, alpha: 1),
                    inputFieldTextColor: .white,
                    inputFieldPlaceholderTextColor: .white,
                    inputFieldErrorColor: #colorLiteral(red: 1, green: 0.7788988948, blue: 0.1741508245, alpha: 1)
                )
            }
        }
    }
}


