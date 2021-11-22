//
//  BatteryIndicatorView.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 6/3/19.
//

import ReaderSDK2
import UIKit

/*
     +--------------------------------+
     |                        +-----+ |
     |                        |     | |
 +---+                        |     | |
 |   |                        |     | |
 |Cap|           Body         |Chunk| |
 |   |                        |     | |
 +---+                        |     | |
     |                        |     | |
     |                        +-----+ |
     +--------------------------------+
 */

final class BatteryIndicatorView: UIView {
    var theme: Theme {
        didSet {
            render(status.level, isCharging: status.isCharging)
        }
    }

    private static let defaultSize = CGSize(width: 32, height: 16)

    private lazy var bodyLayer = CAShapeLayer()
    private lazy var capLayer = CAShapeLayer()
    private lazy var chunkLayer = CAShapeLayer()

    /// Replicates chunks based on the battery status
    private lazy var chunkReplicatorLayer = CAReplicatorLayer()

    private var animationTimer: Timer? = nil

    var status: ReaderBatteryStatus {
        didSet { statusDidChange() }
    }

    convenience init(theme: Theme) {
        let defaultStatus = ReaderNotChargingBatteryStatus()

        self.init(frame: CGRect(origin: .zero, size: Self.defaultSize), status: defaultStatus, theme: theme)
    }

    init(frame: CGRect, status: ReaderBatteryStatus, theme: Theme) {
        self.status = status
        self.theme = theme
        super.init(frame: frame)

        layer.addSublayer(bodyLayer)
        layer.addSublayer(capLayer)
        layer.addSublayer(chunkReplicatorLayer)
        chunkReplicatorLayer.addSublayer(chunkLayer)

        statusDidChange()
    }

    deinit {
        animationTimer?.invalidate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override var intrinsicContentSize: CGSize {
        return Self.defaultSize
    }

    // MARK: - Layout

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layoutBody()
        layoutCap()
        layoutChunks()
    }

    private func layoutBody() {
        bodyLayer.frame = CGRect(x: capSize.width, y: 0, width: layer.bounds.width - capSize.width, height: layer.bounds.height)
        bodyLayer.path = UIBezierPath(roundedRect: bodyLayer.bounds, cornerRadius: floor(bodyLayer.bounds.height / 5.0)).cgPath
        bodyLayer.lineWidth = lineWidth
    }

    private func layoutCap() {
        capLayer.frame = CGRect(x: 0, y: layer.bounds.midY - capSize.height / 2.0, width: capSize.width, height: capSize.height)
        let capCornerRadius = floor(capSize.height / 4.0)
        let capCornerRadii = CGSize(width: capCornerRadius, height: capCornerRadius)
        capLayer.path = UIBezierPath(roundedRect: capLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: capCornerRadii).cgPath
    }

    private func layoutChunks() {
        // Inset the replicator from the stroke
        chunkReplicatorLayer.frame = bodyLayer.frame.insetBy(dx: lineWidth, dy: lineWidth)

        // Determine the chunk size based on a max of 4 chunks
        let numChunks = 4
        let interChunkPadding = floor(lineWidth / 2.0)
        let chunkSize = CGSize(
            width: (chunkReplicatorLayer.bounds.width - interChunkPadding * CGFloat(numChunks - 1)) / CGFloat(numChunks),
            height: chunkReplicatorLayer.bounds.height
        )

        // Lay out the chunks
        chunkLayer.frame = CGRect(origin: CGPoint(x: chunkReplicatorLayer.bounds.maxX - chunkSize.width, y: 0), size: chunkSize)
        chunkLayer.path = UIBezierPath(roundedRect: chunkLayer.bounds, cornerRadius: floor(chunkSize.width / 5.0)).cgPath
        chunkReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(-chunkSize.width - interChunkPadding, 0, 0)
    }

    // MARK: - Helpers

    private func statusDidChange() {
        animationTimer?.invalidate()
        animationTimer = nil

        if status.isCharging, let nextBatteryLevel = status.level.next {
            animationTimer = Timer(fire: Date(), interval: 0.7, repeats: true) { [weak self] _ in self?.tickChargingAnimation(nextBatteryLevel: nextBatteryLevel) }
            RunLoop.current.add(animationTimer!, forMode: .common)
        } else {
            render(status.level, isCharging: status.isCharging)
        }
    }

    private func render(_ level: ReaderBatteryLevel, isCharging: Bool) {
        let batteryCaseColor = (level == .criticallyLow && !isCharging) ? theme.errorIconColor.cgColor : theme.informationIconColor.cgColor
        capLayer.fillColor = batteryCaseColor
        bodyLayer.strokeColor = batteryCaseColor
        bodyLayer.fillColor = nil

        chunkLayer.fillColor = status.isCharging ? theme.successIconColor.cgColor : theme.informationIconColor.cgColor

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        chunkReplicatorLayer.isHidden = (level == .criticallyLow)
        chunkReplicatorLayer.instanceCount = level.rawValue
        CATransaction.commit()
    }

    private func tickChargingAnimation(nextBatteryLevel: ReaderBatteryLevel) {
        if chunkReplicatorLayer.instanceCount == status.level.rawValue {
            // Render the next battery level
            render(nextBatteryLevel, isCharging: true)
        } else {
            // Render the real battery level again
            render(status.level, isCharging: true)
        }
    }

    private var capSize: CGSize {
        return CGSize(width: floor(bounds.height / 5.0), height: floor(bounds.height / 2.0))
    }

    private var lineWidth: CGFloat {
        return floor(bounds.height / 8.0)
    }
}

extension ReaderBatteryLevel {

    var next: ReaderBatteryLevel? {
        if self == .full {
            // ReaderBatteryLevel(rawValue:) never returns nil since it's an Objective-C enum so we have to guard against invalid rawValues ourselves
            return nil
        }
        return ReaderBatteryLevel(rawValue: rawValue + 1)
    }
}
