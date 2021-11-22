//
//  UIView+Extensions.swift
//  ReaderSDK2UI
//
//  Created by Matias Seijas on 9/3/21.
//  Copyright © 2021 Square, Inc. All rights reserved.
//

import UIKit

extension UIView {
    var isVisible: Bool {
        get { return !isHidden }
        set { isHidden = !newValue }
    }
}
