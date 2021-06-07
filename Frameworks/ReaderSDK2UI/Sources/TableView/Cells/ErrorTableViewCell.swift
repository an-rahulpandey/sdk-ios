//
//  ErrorTableViewCell.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 3/25/19.
//

import ReaderSDK2
import UIKit

public final class ErrorTableViewCell: UITableViewCell, Themable {

    public var theme: Theme = .init() {
        didSet {
            detailTextLabel?.textColor = theme.titleColor

            backgroundColor = .clear
            tintColor = theme.errorIconColor
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        backgroundColor = theme.tertiaryBackgroundColor

        setUpSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        textLabel?.text = nil
    }
}

// MARK: - Private Methods
private extension ErrorTableViewCell {

    private func setUpSubviews() {
        contentView.preservesSuperviewLayoutMargins = true
        contentView.layoutMargins.top = ReaderSDK2UILayout.tableViewCellMargin
        contentView.layoutMargins.bottom = ReaderSDK2UILayout.tableViewCellMargin

        detailTextLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        detailTextLabel?.numberOfLines = 2
    }
}
