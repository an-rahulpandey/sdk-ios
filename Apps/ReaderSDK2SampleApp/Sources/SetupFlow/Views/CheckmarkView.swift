//
//  CheckmarkView.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/18/19.
//

import ReaderSDK2
import UIKit

final class CheckmarkView: UIView {

    var isChecked = false {
        didSet {
            setNeedsDisplay()
        }
    }

    private var theme: Theme = .init()

    convenience init(theme: Theme) {
        self.init()
        self.theme = theme
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 32, height: 32)
    }

    override func draw(_ rect: CGRect) {
        if isChecked {
            let image = UIImage(named: "permissions-checkmark", in: .r2SampleAppResources, compatibleWith: nil)!
            image.draw(in: rect)
        } else {
            drawStroke(color: theme.tintColor, in: rect)
        }
    }

    private func drawStroke(color: UIColor, in rect: CGRect) {
        color.setStroke()
        let lineWidth: CGFloat = 2.0
        let strokeRect = rect.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        let path = UIBezierPath(ovalIn: strokeRect)
        path.lineWidth = lineWidth
        path.stroke()
    }
}
