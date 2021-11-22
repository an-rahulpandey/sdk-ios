//
//  ReaderTableViewCell.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 6/3/19.
//

import ReaderSDK2
import UIKit

class ReaderNotChargingBatteryStatus: NSObject, ReaderBatteryStatus {
    public var level: ReaderBatteryLevel = .low
    public var percentage: UInt = 0
    public var isCharging: Bool = false
}

extension Row {
    static func reader(
        theme: Theme,
        reader: ReaderInfo,
        tapHandler: @escaping TapHandler,
        leadingSwipeActions: SwipeHandler? = nil,
        trailingSwipeActions: SwipeHandler? = nil
    ) -> Row {
        return Row(
            theme: theme,
            tapHandler: tapHandler,
            leadingSwipeActions: leadingSwipeActions,
            trailingSwipeActions: trailingSwipeActions
        ) { (cell: ReaderTableViewCell) in
            cell.properties = ReaderTableViewCell.Properties(theme: theme, readerInfo: reader)
            cell.accessoryType = .disclosureIndicator
        }
    }
}

final class ReaderTableViewCell: UITableViewCell, Themable {
    struct Properties {
        let theme: Theme
        let readerInfo: ReaderInfo?

        init() {
            self.theme = .init()
            self.readerInfo = nil
        }

        init(theme: Theme, readerInfo: ReaderInfo?) {
            self.theme = theme
            self.readerInfo = readerInfo
        }
    }

    private lazy var nameLabel = makeNameLabel()
    private lazy var stateLabel = makeStateLabel()
    private lazy var batteryIndicator = makeBatteryIndicator()

    var properties: Properties = Properties() {
        didSet {
            configure(properties: properties)
        }
    }

    var theme: Theme = Properties().theme {
        didSet {
            properties = Properties(
                theme: theme,
                readerInfo: properties.readerInfo
            )
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setupSubviews()

        tintColor = theme.tintColor

        selectedBackgroundView = UIView(backgroundColor: theme.tertiaryBackgroundColor.highlighted)

        configure(properties: properties)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(properties: Properties) {
        // Theme Properties
        let theme = properties.theme

        nameLabel.textColor = theme.titleColor
        stateLabel.textColor = {
            if let state = properties.readerInfo?.state, state == .failedToConnect {
                return theme.errorIconColor
            }

            return theme.subtitleColor
        }()
        batteryIndicator.theme = theme

        backgroundColor = theme.tertiaryBackgroundColor
        selectedBackgroundView?.backgroundColor = theme.tertiaryBackgroundColor.highlighted
        tintColor = theme.tintColor

        // Reader Properties
        guard let readerInfo = properties.readerInfo else { return }

        nameLabel.text = readerInfo.name
        stateLabel.text = {
            if let firmwareInfo = readerInfo.firmwareInfo, readerInfo.state == ReaderState.updatingFirmware {
                return "\(readerInfo.state.description) \(firmwareInfo.updatePercentage)%"
            }

            return readerInfo.state.description
        }()

        batteryIndicator.status = readerInfo.batteryStatus ?? ReaderNotChargingBatteryStatus()
        batteryIndicator.isHidden = (readerInfo.batteryStatus == nil)
    }
}

// MARK: - Private Methods
private extension ReaderTableViewCell {

    func setupSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(batteryIndicator)
        contentView.addSubview(stateLabel)

        contentView.preservesSuperviewLayoutMargins = true
        contentView.layoutMargins.top = ReaderSDK2UILayout.tableViewCellMargin
        contentView.layoutMargins.bottom = ReaderSDK2UILayout.tableViewCellMargin

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),

            batteryIndicator.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            batteryIndicator.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            stateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            stateLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }

    func makeNameLabel() -> UILabel {
        let label = makeLabel(font: .systemFont(ofSize: 17, weight: .bold), color: theme.titleColor)
        label.numberOfLines = 0
        return label
    }

    func makeStateLabel() -> UILabel {
        let label = makeLabel(font: .systemFont(ofSize: 14, weight: .regular), color: theme.subtitleColor)
        label.textAlignment = .right
        return label
    }

    func makeBatteryIndicator() -> BatteryIndicatorView {
        let indicator = BatteryIndicatorView(theme: theme)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }

    func makeLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        return label
    }
}
