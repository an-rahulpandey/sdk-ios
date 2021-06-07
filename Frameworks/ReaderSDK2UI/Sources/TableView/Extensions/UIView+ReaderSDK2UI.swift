//
//  UIView+ReaderSDK2UI.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 12/3/19.
//

import Foundation


extension UIView {
    public convenience init(backgroundColor: UIColor) {
        self.init()

        self.backgroundColor = backgroundColor
    }
}

public enum ColoredView {
    public static func makeWithBackgroundColor(_ color: UIColor) -> UIView {
        return UIView(backgroundColor: color)
    }
}
