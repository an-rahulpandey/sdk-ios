//
//  UIViewExtensions.swift
//  ReaderSDK2-SampleApp
//
//  Created by Mike Silvis on 9/25/19.
//

import UIKit

public extension UIView {
    func pinToEdges(of layoutGuide: UILayoutGuide, additionalInsets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: additionalInsets.left),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -additionalInsets.right),
            safeAreaLayoutGuide.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: additionalInsets.top),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -additionalInsets.bottom),
        ])
    }
}
