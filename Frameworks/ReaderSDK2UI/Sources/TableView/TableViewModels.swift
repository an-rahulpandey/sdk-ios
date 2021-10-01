//
//  TableViewModels.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 3/28/19.
//

import ReaderSDK2
import UIKit

public struct Section {
    public var title: String?
    public var rows: [Row]

    public init(title: String? = nil, rows: [Row]) {
        self.title = title
        self.rows = rows
    }
}

public protocol Themable {
    var theme: Theme { get set }
}

public struct Row {
    public typealias TapHandler = () -> Void
    public typealias SwipeHandler = () -> UISwipeActionsConfiguration?

    public let cellType: UITableViewCell.Type
    public let tapHandler: TapHandler?
    public let configureCell: (UITableViewCell) -> Void

    public let leadingSwipeActions: SwipeHandler?
    public let trailingSwipeActions: SwipeHandler?

    private let theme: Theme

    public init<CellType: UITableViewCell & Themable>(
        theme: Theme,
        tapHandler: TapHandler? = nil,
        leadingSwipeActions: SwipeHandler? = nil,
        trailingSwipeActions: SwipeHandler? = nil,
        _ configureCell: @escaping (CellType) -> Void
    ) {
        self.cellType = CellType.self
        self.theme = theme
        self.tapHandler = tapHandler
        self.leadingSwipeActions = leadingSwipeActions
        self.trailingSwipeActions = trailingSwipeActions

        self.configureCell = { untypedCell in
            guard var cell = untypedCell as? CellType else { fatalError("Expected cell of type \(String(describing: CellType.self)).") }
            cell.theme = theme
            configureCell(cell)
        }
    }

    public var reuseIdentifier: String {
        return String(describing: cellType)
    }
}

// MARK: - Helpers for common row types
public extension Row {

    static func horizontal(theme: Theme, title: String?, description: String? = nil, image: UIImage? = nil, accessoryType: UITableViewCell.AccessoryType = .none, tapHandler: TapHandler? = nil) -> Row {
        return Row(theme: theme, tapHandler: tapHandler) { (cell: HorizontalTableViewCell) in
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = description
            cell.imageView?.image = image
            cell.accessoryType = accessoryType
        }
    }

    static func error(theme: Theme, description: String? = nil) -> Row {
        return Row(theme: theme) { (cell: ErrorTableViewCell) in
            cell.textLabel?.text = description
        }
    }

    static func button(theme: Theme, title: String, tapHandler: @escaping TapHandler) -> Row {
        return Row(theme: theme, tapHandler: tapHandler) { (cell: ButtonTableViewCell) in
            cell.titleLabel.text = title
        }
    }

    static func toggle(theme: Theme, title: String, initialState: Bool, onToggle: @escaping (Bool) -> Void) -> Row {
        return Row(theme: theme) { (cell: ToggleTableViewCell) in
            cell.titleLabel.text = title
            cell.toggle.isOn = initialState
            cell.onToggle = onToggle
        }
    }

    static func input(
        theme: Theme,
        title: String,
        initialState: MoneyAmount?,
        currency: Currency,
        onChange: @escaping (Money?) -> Void
    ) -> Row {

        func moneyFromString(_ string: String?) -> Money? {
            var string = string
            string?.removeAll { !$0.isNumber }
            let amount = string.flatMap(UInt.init)
            return amount.map { amount in Money(amount: amount, currency: currency) }
        }

        return input(
            theme: theme,
            title: title,
            initialState: initialState?.description,
            keyboardType: .numberPad,
            formatter: { text in
                let money = moneyFromString(text)
                return money?.amount == 0 ? nil : money?.description
            },
            onChange: { amountString in onChange(moneyFromString(amountString)) }
        )
    }

    static func input(
        theme: Theme,
        title: String,
        initialState: String? = nil,
        keyboardType: UIKeyboardType = .default,
        formatter: @escaping (String?) -> String? = { $0 },
        onChange: @escaping (String?) -> Void
    ) -> Row {
        return Row(theme: theme) { (cell: InputTableViewCell) in
            cell.titleLabel.text = title
            cell.textField.text = initialState
            cell.textField.keyboardType = keyboardType
            cell.inputFormatter = formatter
            cell.onChange = onChange
        }
    }
}
