//
//  InputTableViewCell.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 10/14/19.
//

import ReaderSDK2
import UIKit

public final class InputTableViewCell: UITableViewCell, Themable {
    private(set) lazy var titleLabel = makeTitleLabel()
    private(set) lazy var textField = makeTextField()
    public var theme: Theme = .init() {
        didSet {
            titleLabel.textColor = theme.titleColor
            textField.textColor = theme.titleColor

            backgroundColor = theme.tertiaryBackgroundColor
            selectedBackgroundView?.backgroundColor = theme.tertiaryBackgroundColor.highlighted
        }
    }

    public var inputFormatter: (String?) -> String? = { $0 }
    public var onChange: ((String?) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupSubviews()

        backgroundColor = theme.tertiaryBackgroundColor
        selectedBackgroundView = UIView(backgroundColor: theme.tertiaryBackgroundColor.highlighted)

        textField.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        onChange = nil
    }
}

// MARK: - Private Methods
private extension InputTableViewCell {

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)

        contentView.preservesSuperviewLayoutMargins = true
        contentView.layoutMargins.top = ReaderSDK2UILayout.tableViewCellMargin
        contentView.layoutMargins.bottom = ReaderSDK2UILayout.tableViewCellMargin

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -18),

            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textColor = theme.titleColor

        return label
    }

    private func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        textField.textAlignment = .right
        textField.returnKeyType = .done
        textField.textColor = theme.titleColor
        return textField
    }

    @objc func didChangeText(_ textField: UITextField) {
        let newText = inputFormatter((textField.text?.isEmpty == true) ? nil : textField.text)
        textField.text = newText
        textField.clearButtonMode = (newText == nil) ? .never : .always
        onChange?(newText)
    }
}

// MARK: - UITextFieldDelegate
extension InputTableViewCell: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
