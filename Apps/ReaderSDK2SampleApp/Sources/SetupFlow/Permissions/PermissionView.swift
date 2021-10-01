//
//  PermissionCell.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/18/19.
//

import ReaderSDK2
import UIKit

protocol PermissionViewDelegate: AnyObject {
    func permissionView(_ permissionView: PermissionView, didTap permission: Permission)
}

final class PermissionView: UIView {
    let permission: Permission
    private weak var delegate: PermissionViewDelegate?

    private lazy var permissionLabel = makeLabel(font: .systemFont(ofSize: 17, weight: .bold), color: theme.titleColor)
    private lazy var reasonLabel = makeLabel(font: .systemFont(ofSize: 14, weight: .regular), color: theme.subtitleColor)
    private lazy var checkmarkView = makeCheckmarkView()

    private let theme: Theme

    init(theme: Theme, permission: Permission, delegate: PermissionViewDelegate) {
        self.theme = theme
        self.permission = permission
        self.delegate = delegate
        super.init(frame: .zero)

        preservesSuperviewLayoutMargins = true
        layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)

        permissionLabel.text = permission.prompt
        reasonLabel.text = permission.reason

        addSubview(permissionLabel)
        addSubview(reasonLabel)
        addSubview(checkmarkView)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.permissionView(self, didTap: permission)
    }

    func reloadCheckmark() {
        checkmarkView.isChecked = (permission.status == .granted)
    }
}

// MARK: - Private Methods
private extension PermissionView {

    func makeLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = font
        label.textColor = color
        return label
    }

    func makeCheckmarkView() -> CheckmarkView {
        let checkmarkView = CheckmarkView(theme: theme)
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        return checkmarkView
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // permissionLabel
            permissionLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            permissionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            permissionLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            // reasonLabel
            reasonLabel.topAnchor.constraint(equalTo: permissionLabel.bottomAnchor, constant: 8),
            reasonLabel.leadingAnchor.constraint(equalTo: permissionLabel.leadingAnchor),
            reasonLabel.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor, multiplier: 0.83),
            reasonLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),

            // checkmarkView
            checkmarkView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
            checkmarkView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
