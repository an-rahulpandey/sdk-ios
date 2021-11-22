//
//  PaymentOptionsViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 9/19/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

final class PaymentOptionsViewController: UITableViewController {
    private lazy var dataSource = TableViewDataSource(theme: theme, tableView: tableView, sections: makeSections())
    private let theme: Theme
    private let authorizationManager: AuthorizationManager

    init(theme: Theme, authorizationManager: AuthorizationManager) {
        self.theme = theme
        self.authorizationManager = authorizationManager
        super.init(style: .grouped)
        title = Strings.Settings.paymentOptionsTitle
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload the data on appearance
        dataSource.sections = makeSections()
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
private extension PaymentOptionsViewController {
    func makeSections() -> [Section] {
        let rows: [Row] = [
            .toggle(theme: theme, title: "Autocomplete", initialState: Config.parameters.autocomplete, onToggle: { newValue in
                Config.parameters.autocomplete = newValue
            }),
            .input(theme: theme, title: "tipMoney", initialState: Config.parameters.tipMoney, currency: currency, onChange: { newValue in
                Config.parameters.tipMoney = newValue
            }),
            .input(theme: theme, title: "appFeeMoney", initialState: Config.parameters.appFeeMoney, currency: currency, onChange: { newValue in
                Config.parameters.appFeeMoney = newValue
            }),
            .input(theme: theme, title: "orderID", initialState: Config.parameters.orderID, onChange: { newValue in
                Config.parameters.orderID = newValue
            }),
            .input(theme: theme, title: "referenceID", initialState: Config.parameters.referenceID, onChange: { newValue in
                Config.parameters.referenceID = newValue
            }),
            .input(theme: theme, title: "customerID", initialState: Config.parameters.customerID, onChange: { newValue in
                Config.parameters.customerID = newValue
            }),
            .input(theme: theme, title: "note", initialState: Config.parameters.note, onChange: { newValue in
                Config.parameters.note = newValue
            }),
            .input(theme: theme, title: "statementDescriptionIdentifier", initialState: Config.parameters.statementDescriptionIdentifier, onChange: { newValue in
                Config.parameters.statementDescriptionIdentifier = newValue
            }),
        ]
        return [Section(rows: rows)]
    }

    private var currency: Currency {
        return authorizationManager.authorizedLocation?.currency ?? .USD
    }
}
