//
//  HorizontalTableViewCell.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 3/25/19.
//

import ReaderSDK2
import UIKit

public final class HorizontalTableViewCell: UITableViewCell, Themable {

    public var theme: Theme = .init() {
        didSet {
            imageView?.tintColor = theme.titleColor

            textLabel?.textColor = theme.titleColor
            detailTextLabel?.textColor = theme.subtitleColor

            backgroundColor = theme.tertiaryBackgroundColor
            selectedBackgroundView?.backgroundColor = theme.tertiaryBackgroundColor.highlighted
            tintColor = theme.tintColor
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        backgroundColor = theme.tertiaryBackgroundColor

        setUpSubviews()

        selectedBackgroundView = UIView(backgroundColor: theme.tertiaryBackgroundColor.highlighted)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        textLabel?.text = nil
        detailTextLabel?.text = nil
        imageView?.image = nil
    }
}

// MARK: - Private Methods
private extension HorizontalTableViewCell {

    private func setUpSubviews() {
        contentView.preservesSuperviewLayoutMargins = true
        contentView.layoutMargins.top = ReaderSDK2UILayout.tableViewCellMargin
        contentView.layoutMargins.bottom = ReaderSDK2UILayout.tableViewCellMargin

        textLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        textLabel?.numberOfLines = 2

        detailTextLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        detailTextLabel?.numberOfLines = 2
    }
}
