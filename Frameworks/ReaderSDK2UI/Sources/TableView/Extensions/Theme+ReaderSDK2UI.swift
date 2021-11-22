//
//  Theme+ReaderSDK2UI.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 12/3/19.
//

import Foundation
import ReaderSDK2
import UIKit

public enum ColorGenerator {
    public static func secondaryBackgroundColor(theme: Theme) -> UIColor {
        if theme.backgroundColor.isLightColor {
            return theme.backgroundColor.dimmed()
        }

        return theme.backgroundColor
    }

    public static func tertiaryBackgroundColor(theme: Theme) -> UIColor {
        if theme.backgroundColor.isLightColor {
            return theme.backgroundColor
        }

        return theme.backgroundColor.brightened()
    }

    public static func borderColor(theme: Theme) -> UIColor {
        return secondaryBackgroundColor(theme: theme).dimmed(0.2)
    }

    public static func statusBarStyle(theme: Theme) -> UIStatusBarStyle {
        return theme.backgroundColor.isLightColor ? .default : .lightContent
    }

    public static func barStyle(theme: Theme) -> UIBarStyle {
        return theme.backgroundColor.isLightColor ? .default : .black
    }

    public static func disabled(color: UIColor) -> UIColor {
        return color.disabled
    }

    public static func highlighted(color: UIColor) -> UIColor {
        return color.highlighted
    }
}

public extension Theme {
    var secondaryBackgroundColor: UIColor {
        return ColorGenerator.secondaryBackgroundColor(theme: self)
    }

    var tertiaryBackgroundColor: UIColor {
        return ColorGenerator.tertiaryBackgroundColor(theme: self)
    }

    var borderColor: UIColor {
        return ColorGenerator.borderColor(theme: self)
    }

    var barStyle: UIBarStyle {
        return ColorGenerator.barStyle(theme: self)
    }

    var statusBarStyle: UIStatusBarStyle {
        return ColorGenerator.statusBarStyle(theme: self)
    }
}
