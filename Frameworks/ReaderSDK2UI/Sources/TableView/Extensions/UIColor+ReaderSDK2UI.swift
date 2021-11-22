//
//  UIColor+ReaderSDK2UI.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 12/2/19.
//

import UIKit

extension UIColor {
    var isLightColor: Bool {
        return rgba.red * 0.299 + rgba.green * 0.787 + rgba.blue * 0.114 > 0.72
    }

    var disabled: UIColor {
        return withAlphaComponent(0.5)
    }

    var highlighted: UIColor {
        return withAlphaComponent(0.7)
    }

    func dimmed(_ amount: CGFloat = 0.05) -> UIColor {
        let dimmedColor: () -> UIColor = {
            return UIColor(
                hue: self.hsba.hue,
                saturation: self.hsba.saturation,
                brightness: min(1.0, self.hsba.brightness - amount),
                alpha: 1.0
            )
        }

        if #available(iOS 13, *) {
            return UIColor { _ -> UIColor in
                return dimmedColor()
            }
        }

        return dimmedColor()
    }

    func brightened(_ amount: CGFloat = 0.05) -> UIColor {
        let brightenedColor: () -> UIColor = {
            return UIColor(
                hue: self.hsba.hue,
                saturation: self.hsba.saturation,
                brightness: max(0.0, self.hsba.brightness + amount),
                alpha: 1.0
            )
        }

        if #available(iOS 13, *) {
            return UIColor { _ -> UIColor in
                return brightenedColor()
            }
        }

        return brightenedColor()
    }

    // MARK: Constructors

    @objc private convenience init(fromHex hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b, a: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // RGBA (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (1, 1, 1, 0)
        }

        self.init(CGFloat(r), CGFloat(g), CGFloat(b), CGFloat(a))
    }

    private convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    // MARK: Values

    private var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
        self.getHue(&hsba.hue, saturation: &hsba.saturation, brightness: &hsba.brightness, alpha: &hsba.alpha)
        return hsba
    }

    private var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
        self.getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha)
        return rgba
    }
}

