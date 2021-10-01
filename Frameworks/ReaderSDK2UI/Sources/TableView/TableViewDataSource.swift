//
//  TableViewDataSource.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 3/28/19.
//

import ReaderSDK2
import UIKit

public final class TableViewDataSource: NSObject,
    UITableViewDelegate,
    UITableViewDataSource
{
    private let tableView: UITableView
    private let theme: Theme

    public var sections: [Section] {
        didSet { sectionsDidChange() }
    }

    public init(theme: Theme, tableView: UITableView, sections: [Section]) {
        self.theme = theme
        self.tableView = tableView
        self.sections = sections
        super.init()
        sectionsDidChange()
    }

    // MARK: - Table View

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return sections[sectionIndex].rows.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        row.configureCell(cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        // Allow the cell to be tapped if the row has a tap handler
        return row(at: indexPath).tapHandler != nil
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row(at: indexPath).tapHandler?()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as? UITableViewHeaderFooterView
        headerView?.textLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        headerView?.textLabel?.textColor = theme.titleColor.withAlphaComponent(0.7)
    }

    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return row(at: indexPath).leadingSwipeActions?()
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return row(at: indexPath).trailingSwipeActions?()
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let hasLeadingActions = row(at: indexPath).leadingSwipeActions?() != nil
        let hasTrailingActions = row(at: indexPath).trailingSwipeActions?() != nil

        return hasLeadingActions || hasTrailingActions
    }

    // MARK: - Helpers

    private func row(at indexPath: IndexPath) -> Row {
        return sections[indexPath.section].rows[indexPath.row]
    }

    private func sectionsDidChange() {
        sections.flatMap { $0.rows }.forEach { row in
            tableView.register(row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
        }
    }
}
