//
//  VerticalTableViewCell.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 10/25/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

extension Row {
    static func vertical(theme: Theme, title: String?, description: String?, tapHandler: TapHandler? = nil) -> Row {
        return Row(theme: theme, tapHandler: tapHandler) { (cell: VerticalTableViewCell) in
            cell.titleLabel.text = title
            cell.descriptionLabel.text = description
        }
    }
}

final class VerticalTableViewCell: UITableViewCell, Themable {
    private(set) lazy var titleLabel = makeTitleLabel()
    private(set) lazy var descriptionLabel = makeDescriptionLabel()

    var theme: Theme = .init() {
        didSet {
            titleLabel.textColor = theme.titleColor
            descriptionLabel.textColor = theme.subtitleColor
            backgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)
            selectedBackgroundView?.backgroundColor = ColorGenerator.highlighted(
                color: ColorGenerator.tertiaryBackgroundColor(theme: theme)
            )
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        backgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)

        setupSubviews()

        selectedBackgroundView = ColoredView.makeWithBackgroundColor(
            ColorGenerator.highlighted(
                color: ColorGenerator.tertiaryBackgroundColor(theme: theme)
            )
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension VerticalTableViewCell {

    private func setupSubviews() {
        let stackView = makeStackView()

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        contentView.addSubview(stackView)

        contentView.preservesSuperviewLayoutMargins = true
        contentView.layoutMargins.top = ReaderSDK2UILayout.tableViewCellMargin
        contentView.layoutMargins.bottom = ReaderSDK2UILayout.tableViewCellMargin

        stackView.pinToEdges(of: contentView.layoutMarginsGuide)
    }

    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }

    private func makeTitleLabel() -> UILabel {
        let label = makeLabel(font: .systemFont(ofSize: 16, weight: .bold), color: theme.titleColor)
        label.numberOfLines = 0
        return label
    }

    private func makeDescriptionLabel() -> UILabel {
        let label = makeLabel(font: .systemFont(ofSize: 16, weight: .regular), color: theme.subtitleColor)
        label.numberOfLines = 0
        return label
    }

    private func makeLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        return label
    }
}
