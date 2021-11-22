//
//  ReadersViewController.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 9/23/19.
//

import ReaderSDK2
import UIKit

public final class ReadersViewController: UITableViewController {
    private var displayedReaders: [ReaderInfo] = [] {
        didSet {
            dataSource.sections = makeSections()
        }
    }

    private let theme: Theme
    private let readerManager: ReaderManager

    private lazy var dataSource = TableViewDataSource(theme: theme, tableView: tableView, sections: makeSections())

    public init(theme: Theme, readerManager: ReaderManager) {
        self.theme = theme
        self.readerManager = readerManager

        super.init(style: .grouped)

        title = ReaderSDK2UIStrings.Readers.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.secondaryBackgroundColor
        configure(tableView: tableView)

        displayedReaders = readerManager.readers
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

    private func configure(tableView: UITableView) {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
}

// MARK: - Reader Observer
extension ReadersViewController: ReaderObserver {

    public func readerWasAdded(_ readerInfo: ReaderInfo) {
        tableView.performBatchUpdates({
            displayedReaders.append(readerInfo)
            tableView.insertRows(at: [IndexPath(row: displayedReaders.count - 1, section: 0)], with: .left)
        })
    }

    public func readerWasRemoved(_ readerInfo: ReaderInfo) {
        guard let index = displayedReaders.firstIndex(where: { return $0.id == readerInfo.id }) else {
            return
        }
        tableView.performBatchUpdates({
            displayedReaders.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        })
    }

    public func readerDidChange(_ readerInfo: ReaderInfo, change: ReaderChange) {
        guard change != .firmwareUpdateDidFail else {
            let alertVC = UIAlertController(title: ReaderSDK2UIStrings.ReaderDetail.firmwareFailedAlertTitle, message: readerInfo.firmwareInfo?.failureReason?.localizedDescription, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: ReaderSDK2UIStrings.errorDismissButtonTitle, style: .cancel, handler: nil))
            present(alertVC, animated: false, completion: nil)
            return
        }

        displayedReaders = readerManager.readers
        dataSource.sections = makeSections()
        tableView.reloadData()
    }
}

// MARK: - Helpers
extension ReadersViewController {
    private func makeSections() -> [Section] {
        let readerRows = displayedReaders.map(makeRow)

        let connectReaderRow = Row.button(
            theme: theme,
            title: ReaderSDK2UIStrings.Readers.connectReaderButtonTitle,
            tapHandler: { [weak self] in self?.connectReaderButtonPressed() }
        )

        return [
            Section(title: ReaderSDK2UIStrings.Readers.hardwareSectionTitle, rows: readerRows + [connectReaderRow]),
        ]
    }

    private func makeRow(for readerInfo: ReaderInfo) -> Row {
        return .reader(
            theme: theme,
            reader: readerInfo,
            tapHandler: { [weak self] in self?.readerPressed(readerInfo) },
            leadingSwipeActions: {
                guard readerInfo.canBlink else {
                    return nil
                }

                let blinkTitle = ReaderSDK2UIStrings.ReaderSwipeActions.identify
                let blinkAction = UIContextualAction(
                    style: .normal, title: blinkTitle,
                    handler: { [weak self] action, view, completionHandler in
                    guard let strongSelf = self else {
                        completionHandler(false)
                        return
                    }

                    strongSelf.readerManager.blink(readerInfo)

                    completionHandler(true)
                    }
                )

                blinkAction.backgroundColor = .systemYellow
                let configuration = UISwipeActionsConfiguration(actions: [blinkAction])
                configuration.performsFirstActionWithFullSwipe = true
                return configuration
            },
            trailingSwipeActions: {
                guard readerInfo.canForget else {
                    return nil
                }

                let forgetTitle = ReaderSDK2UIStrings.ReaderSwipeActions.forget
                let forgetAction = UIContextualAction(
                    style: .destructive, title: forgetTitle,
                    handler: { [weak self] action, view, completionHandler in
                    guard let strongSelf = self else {
                        completionHandler(false)
                        return
                    }

                    strongSelf.readerManager.forget(readerInfo)
                    completionHandler(true)
                    }
                )

                let configuration = UISwipeActionsConfiguration(actions: [forgetAction])
                configuration.performsFirstActionWithFullSwipe = true
                return configuration
            }
        )
    }

    func readerPressed(_ readerInfo: ReaderInfo) {
        let readerDetail = ReaderDetailViewController(
            readerInfo: readerInfo,
            readerManager: readerManager,
            theme: theme,
            delegate: self
        )
        navigationController?.pushViewController(readerDetail, animated: true)
    }

    func connectReaderButtonPressed() {
        let pairingViewController = ReaderPairingViewController(theme: theme, readerManager: readerManager, delegate: self)
        let navigationController = UINavigationController(rootViewController: pairingViewController)
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true, completion: nil)
    }

    private func showError(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let dismissAction = UIAlertAction(title: ReaderSDK2UIStrings.errorDismissButtonTitle, style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ReaderDetailViewControllerDelegate

extension ReadersViewController: ReaderDetailViewControllerDelegate {
    public func readerDetailViewController(_ readerDetailViewController: ReaderDetailViewController, didBecomeInvalidDueToReaderRemoval removedReader: ReaderInfo) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ReaderPairingViewControllerDelegate

extension ReadersViewController: ReaderPairingViewControllerDelegate {
    public func readerPairingViewControllerDidFinish(_ readerPairingViewController: ReaderPairingViewController) {
        dismiss(animated: true, completion: nil)
    }

    public func readerPairingViewController(_ readerPairingViewController: ReaderPairingViewController, didFailWith error: Error) {
        dismiss(animated: true) {
            self.showError(title: ReaderSDK2UIStrings.ReaderPairing.errorTitle, message: error.localizedDescription)
        }
    }
}

