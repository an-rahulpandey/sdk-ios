//
//  SettingsViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/21/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

#if canImport(MockReaderUI)
import MockReaderUI
#endif

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewControllerDidInitiateLogout(_ settingsViewController: SettingsViewController)
}

final class SettingsViewController: UITableViewController {
    typealias SettingsViewAndMockReaderUIDelegate = SettingsViewControllerDelegate & MockReaderUIPresentationDelegate

    private weak var delegate: SettingsViewAndMockReaderUIDelegate?
    private let authorizationManager: AuthorizationManager
    private lazy var dataSource = TableViewDataSource(theme: theme, tableView: tableView, sections: makeSections())
    private let theme: Theme

    init(theme: Theme, authorizationManager: AuthorizationManager, delegate: SettingsViewAndMockReaderUIDelegate?) {
        self.theme = theme
        self.authorizationManager = authorizationManager
        self.delegate = delegate
        super.init(style: .grouped)
        title = Strings.TabBar.settings
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        view.backgroundColor = ColorGenerator.secondaryBackgroundColor(theme: theme)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutMargins = ReaderSDK2UILayout.preferredMargins(view: view)
        tableView.separatorInset = view.layoutMargins
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorGenerator.statusBarStyle(theme: theme)
    }
}

// MARK: - Table View Helpers
private extension SettingsViewController {

    var selectedThemeName: String {
        let desiredTheme = Theme.Option.allCases.first { option -> Bool in
            return option.theme == Config.theme
        }

        return desiredTheme?.description ?? "Custom"
    }

    private var sandboxSection: Section? {
        guard ReaderSDK.shared.isSandboxEnvironment else { return nil }

        // Mock Reader Row
        let mockReaderVisibilityRow = Row.toggle(
            theme: theme,
            title: Strings.Settings.mockReaderVisibilityRowTitle,
            initialState: true,
            onToggle: { [weak self] value in
                self?.delegate?.toggleMockReaderUI(enabled: value)
            }
        )

#if canImport(MockReaderUI)
        return
            Section(
                title: Strings.Settings.mockReaderSectionTitle,
                rows: [mockReaderVisibilityRow]
            )
#else
        return nil
#endif
    }

    func makeSections() -> [Section] {
        // General rows
        let themeRow = Row.horizontal(theme: theme, title: Strings.Settings.themeRowTitle, description: selectedThemeName, accessoryType: .disclosureIndicator, tapHandler: { [weak self] in
            self?.themeRowPressed()
        })
        let paymentOptionsRow = Row.horizontal(theme: theme, title: Strings.Settings.paymentOptionsTitle, description: nil, accessoryType: .disclosureIndicator, tapHandler: { [weak self] in
            self?.paymentOptionsRowPressed()
        })

        // Location Rows
        let locationName = Row.horizontal(
            theme: theme,
            title: Strings.Settings.locationRowTitle,
            description: authorizationManager.authorizedLocation!.name
        )

        let deauthorizeRow = Row.button(theme: theme, title: Strings.Settings.deauthorizeButtonTitle, tapHandler: { [weak self] in
            self?.deauthorizeButtonPressed()
        })

        return [
            Section(
                title: Strings.Settings.generalSectionTitle,
                rows: [themeRow, paymentOptionsRow]
            ),
            sandboxSection,
            Section(
                title: Strings.Settings.locationSectionTitle,
                rows: [locationName, deauthorizeRow]
            ),
        ].compactMap { $0 }
    }
}

// MARK: - Actions
private extension SettingsViewController {

    func deauthorizeButtonPressed() {
        delegate?.settingsViewControllerDidInitiateLogout(self)
    }

    func themeRowPressed() {
        let themePicker = ThemePickerViewController(theme: theme)
        themePicker.delegate = self
        navigationController?.pushViewController(themePicker, animated: true)
    }

    func paymentOptionsRowPressed() {
        let paymentOptionsChanger = PaymentOptionsViewController(theme: theme, authorizationManager: authorizationManager)
        navigationController?.pushViewController(paymentOptionsChanger, animated: true)
    }
}

// MARK: - ThemePickerViewControllerDelegate
extension SettingsViewController: ThemePickerViewControllerDelegate {

    func themePickerViewController(_ themePickerViewController: ThemePickerViewController, didChangeTheme theme: Theme) {
        dataSource.sections = makeSections()
        tableView.reloadData()
    }
}
