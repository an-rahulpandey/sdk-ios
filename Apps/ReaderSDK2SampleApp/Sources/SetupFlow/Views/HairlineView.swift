//
//  HairlineView.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/19/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

final class HairlineView: UIView {
    enum Orientation {
        case horizontal, vertical
    }

    private let orientation: Orientation

    init(theme: Theme, orientation: Orientation = .horizontal) {
        self.orientation = orientation

        super.init(frame: .zero)

        setContentHuggingPriority(.required, for: .vertical)

        backgroundColor = ColorGenerator.borderColor(theme: theme)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let thickness = 1.0 / UIScreen.main.scale

        switch orientation {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: thickness)
        case .vertical:
            return CGSize(width: thickness, height: UIView.noIntrinsicMetric)
        }
    }
}
