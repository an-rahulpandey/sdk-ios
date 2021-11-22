//
//  ToggleTableViewCell.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 9/19/19.
//

import ReaderSDK2
import UIKit

public final class ToggleTableViewCell: UITableViewCell, Themable {
    public var theme: Theme = .init() {
        didSet {
            titleLabel.textColor = theme.titleColor
            toggle.onTintColor = theme.tintColor

            backgroundColor = theme.tertiaryBackgroundColor
        }
    }

    private(set) lazy var titleLabel = makeTitleLabel()
    private(set) lazy var toggle = makeToggle()
    public var onToggle: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        backgroundColor = theme.tertiaryBackgroundColor

        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        onToggle = nil
    }
}

// MARK: - Private Methods
private extension ToggleTableViewCell {

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggle)

        contentView.preservesSuperviewLayoutMargins = true
        contentView.layoutMargins.top = ReaderSDK2UILayout.tableViewCellMargin
        contentView.layoutMargins.bottom = ReaderSDK2UILayout.tableViewCellMargin

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -18),

            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = theme.titleColor
        return label
    }

    private func makeToggle() -> UISwitch {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(didToggle), for: .valueChanged)
        return toggle
    }

    @objc func didToggle() {
        onToggle?(toggle.isOn)
    }
}
