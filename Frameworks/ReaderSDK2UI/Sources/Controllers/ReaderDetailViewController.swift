//
//  ReaderDetailViewController.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 6/4/19.
//

import ReaderSDK2
import UIKit

public protocol ReaderDetailViewControllerDelegate: AnyObject {
    func readerDetailViewController(_ readerDetailViewController: ReaderDetailViewController, didBecomeInvalidDueToReaderRemoval removedReaderInfo: ReaderInfo)
}

public final class ReaderDetailViewController: UITableViewController {
    private var readerInfo: ReaderInfo
    private let theme: Theme
    private let readerManager: ReaderManager
    private lazy var dataSource = TableViewDataSource(theme: theme, tableView: tableView, sections: makeSections())
    weak var delegate: ReaderDetailViewControllerDelegate?

    public init(readerInfo: ReaderInfo, readerManager: ReaderManager, theme: Theme, delegate: ReaderDetailViewControllerDelegate) {
        self.readerInfo = readerInfo
        self.readerManager = readerManager
        self.theme = theme
        self.delegate = delegate

        super.init(style: .grouped)
        title = readerInfo.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        readerManager.remove(self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = theme.secondaryBackgroundColor

        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        readerManager.add(self)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutMargins = ReaderSDK2UILayout.preferredMargins(view: view)
        tableView.separatorInset = view.layoutMargins
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusBarStyle
    }
}

// MARK: - Table View Helpers
private extension ReaderDetailViewController {

    private func makeSections() -> [Section] {
        var result: [Section] = []

        // Error Rows
        if let failureInfo = readerInfo.connectionInfo.failureInfo, readerInfo.state == .failedToConnect {
            result.append(
                Section(
                    rows: [
                        .error(theme: theme, description: "\(failureInfo.localizedTitle): \(failureInfo.localizedDescription)"),
                    ]
                )
            )
        }

        // General Rows
        result.append(
            Section(
                title: ReaderSDK2UIStrings.ReaderDetail.generalSectionTitle,
                rows: makeGeneralRows()
            )
        )

        // Action Rows
        let actionRows = makeActionRows()

        if !actionRows.isEmpty {
            result.append(Section(rows: actionRows))
        }

        return result
    }

    private func makeGeneralRows() -> [Row] {
        var result: [Row] = [
            .horizontal(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.readerStateRowTitle, description: readerInfo.state.description),
            .horizontal(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.supportedInputMethodsRowTitle, description: readerInfo.supportedInputMethods.description),
        ]

        if let batteryStatus = readerInfo.batteryStatus {
            result.append(.horizontal(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.batteryRowTitle, description: batteryStatus.description))
        }

        if let firmwareVersion = readerInfo.firmwareInfo?.version {
            result.append(.horizontal(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.firmwareRowTitle, description: firmwareVersion))
        }

        result.append(.horizontal(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.serialNumberRowTitle, description: readerInfo.serialNumber))

        return result
    }

    private func makeActionRows() -> [Row] {
        var result: [Row] = []

        if readerInfo.canRetryConnection {
            let button = Row.button(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.reconnectReaderButtonTitle, tapHandler: { [weak self] in
                if let readerInfo = self?.readerInfo {
                    self?.readerManager.retryConnection(readerInfo)
                }
            })

            result.append(button)
        }

        if readerInfo.canBlink {
            let button = Row.button(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.identifyReaderButtonTitle) { [weak self] in
                if let readerInfo = self?.readerInfo {
                    self?.readerManager.blink(readerInfo)
                }
            }

            result.append(button)
        }

        if readerInfo.canForget {
            let button = Row.button(theme: theme, title: ReaderSDK2UIStrings.ReaderDetail.forgetReaderButtonTitle) { [weak self] in
                if let readerInfo = self?.readerInfo {
                    self?.readerManager.forget(readerInfo)
                }
            }

            result.append(button)
        }

        return result
    }
}

// MARK: - ReaderObserver
extension ReaderDetailViewController: ReaderObserver {

    public func readerDidChange(_ readerInfo: ReaderInfo, change: ReaderChange) {
        if readerInfo.id == self.readerInfo.id {
            self.readerInfo = readerInfo
            dataSource.sections = makeSections()
            tableView.reloadData()
        }
    }

    public func readerWasRemoved(_ readerInfo: ReaderInfo) {
        if readerInfo.id == self.readerInfo.id {
            delegate?.readerDetailViewController(self, didBecomeInvalidDueToReaderRemoval: readerInfo)
        }
    }

    public func readerWasAdded(_ readerInfo: ReaderInfo) {}
}
