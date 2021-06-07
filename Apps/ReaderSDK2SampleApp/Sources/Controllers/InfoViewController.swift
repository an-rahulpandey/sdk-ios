//
//  InfoViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 10/25/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

/// Displays keys and values in the provided dictionary
final class InfoViewController: UITableViewController {
    private let theme: Theme
    private let dictionary: [String: Any]
    private lazy var dataSource = TableViewDataSource(theme: theme, tableView: tableView, sections: makeSections())

    init(theme: Theme, title: String, infoDictionary: [String: Any]) {
        self.theme = theme
        self.dictionary = infoDictionary
        super.init(style: .grouped)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorGenerator.secondaryBackgroundColor(theme: theme)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutMargins = ReaderSDK2UILayout.preferredMargins(view: view)
        tableView.separatorInset = view.layoutMargins
    }
}

// MARK: - Helpers
private extension InfoViewController {

    func makeSections() -> [Section] {
        let rows: [Row] = dictionary
            .sorted(by: { entry1, entry2 in entry1.key < entry2.key })
            .map { entry in
                .vertical(
                    theme: theme,
                    title: entry.key,
                    description: String(describing: entry.value),
                    tapHandler: { UIPasteboard.general.string = String(describing: entry.value) }
                )
        }
        return [Section(rows: rows)]
    }
}
