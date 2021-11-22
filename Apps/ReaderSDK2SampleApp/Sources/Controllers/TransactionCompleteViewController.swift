//
//  TransactionCompleteViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 8/19/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

final class TransactionCompleteViewController: UIViewController {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var viewReceiptButton = makeViewReceiptButton()
    private lazy var newTransactionButton = makeNewTransactionButton()
    private lazy var centeredStackView = makeCenteredStackView(with: titleLabel, viewReceiptButton)

    private let payment: Payment
    private let theme: Theme

    init(theme: Theme, payment: Payment) {
        self.theme = theme
        self.payment = payment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.backgroundColor
        view.addSubview(centeredStackView)
        view.addSubview(newTransactionButton)

        NSLayoutConstraint.activate([
            centeredStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centeredStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            centeredStackView.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor),

            viewReceiptButton.widthAnchor.constraint(equalToConstant: 240),

            newTransactionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            newTransactionButton.widthAnchor.constraint(equalTo: viewReceiptButton.widthAnchor),
            newTransactionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorGenerator.statusBarStyle(theme: theme)
    }
}

// MARK: - Helpers
private extension TransactionCompleteViewController {

    func makeCenteredStackView(with contents: UIView...) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: contents)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        return stackView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.TransactionComplete.title
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .black)
        label.textColor = theme.titleColor
        return label
    }

    func makeNewTransactionButton() -> UIButton {
        let button = Button(theme: theme, style: .prominent)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.TransactionComplete.newTransactionButtonTitle, for: [])
        button.addTarget(self, action: #selector(newTransactionButtonPressed), for: .touchUpInside)
        return button
    }

    func makeViewReceiptButton() -> UIButton {
        let button = Button(theme: theme, style: .outline)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.TransactionComplete.viewReceiptButtonTitle, for: [])
        button.addTarget(self, action: #selector(viewReceiptButtonPressed), for: .touchUpInside)
        return button
    }

    @objc func newTransactionButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func dismissReceiptViewer() {
        dismiss(animated: true, completion: nil)
    }

    @objc func viewReceiptButtonPressed() {
        let receiptVC = InfoViewController(
            theme: theme,
            title: "Payment",
            infoDictionary: payment.dictionaryRepresentation
        )
        receiptVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissReceiptViewer)
        )

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(receiptVC, animated: true)
    }
}
