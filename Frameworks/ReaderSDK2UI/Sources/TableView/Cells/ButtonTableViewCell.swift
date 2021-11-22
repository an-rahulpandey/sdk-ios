//
//  ButtonTableViewCell.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 3/25/19.
//

import ReaderSDK2
import UIKit

public final class ButtonTableViewCell: UITableViewCell, Themable {
    public var theme: Theme = .init() {
        didSet {
            titleLabel.textColor = theme.tintColor

            backgroundColor = theme.tertiaryBackgroundColor
            selectedBackgroundView?.backgroundColor = theme.tertiaryBackgroundColor.highlighted
            tintColor = theme.tintColor
        }
    }

    private(set) lazy var titleLabel = makeTitleLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        backgroundColor = theme.tertiaryBackgroundColor

        setupSubviews()

        selectedBackgroundView = UIView(backgroundColor: theme.tertiaryBackgroundColor.highlighted)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension ButtonTableViewCell {

    private func setupSubviews() {
        contentView.addSubview(titleLabel)

        contentView.preservesSuperviewLayoutMargins = true
        contentView.layoutMargins.top = ReaderSDK2UILayout.tableViewCellMargin
        contentView.layoutMargins.bottom = ReaderSDK2UILayout.tableViewCellMargin

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = theme.tintColor
        return label
    }
}
