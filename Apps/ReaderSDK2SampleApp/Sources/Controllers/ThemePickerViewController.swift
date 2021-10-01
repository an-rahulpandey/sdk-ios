//
//  ThemePickerViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 7/16/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

protocol ThemePickerViewControllerDelegate: AnyObject {
    func themePickerViewController(_ themePickerViewController: ThemePickerViewController, didChangeTheme theme: Theme)
}

final class ThemePickerViewController: UITableViewController {
    private lazy var dataSource = TableViewDataSource(theme: theme, tableView: tableView, sections: makeSections())
    weak var delegate: ThemePickerViewControllerDelegate?
    private var theme: Theme

    init(theme: Theme) {
        self.theme = theme
        super.init(style: .grouped)
        title = Strings.Settings.themePickerTitle
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

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorGenerator.statusBarStyle(theme: theme)
    }
}

// MARK: - Helpers
private extension ThemePickerViewController {

    func makeSections() -> [Section] {
        let themeRows: [Row] = Theme.Option.allCases.map { option in
            .horizontal(
                theme: theme,
                title: option.description,
                description: nil,
                accessoryType: (theme == option.theme) ? .checkmark : .none,
                tapHandler: { [weak self] in self?.changeTheme(to: option) }
            )
        }

        return [Section(rows: themeRows)]
    }

    func changeTheme(to option: Theme.Option) {
        showAppRestart(withOption: option) { success in
            guard success else { return }

            Config.theme = option.theme
            self.dataSource.sections = self.makeSections()
            self.tableView.reloadData()
            self.delegate?.themePickerViewController(self, didChangeTheme: option.theme)
        }
    }

    func showAppRestart(withOption option: Theme.Option, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Restart Required", message: "Switching to \(option.description) theme requires the app to restart in order take effect.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in completion(false) })
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in completion(true) })

        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        present(alert, animated: true, completion: nil)
    }
}
