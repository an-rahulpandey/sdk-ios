//
//  ReaderPairingViewController.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 4/8/19.
//

import ReaderSDK2
import UIKit

public protocol ReaderPairingViewControllerDelegate: AnyObject {
    func readerPairingViewControllerDidFinish(_ readerPairingViewController: ReaderPairingViewController)
    func readerPairingViewController(_ readerPairingViewController: ReaderPairingViewController, didFailWith error: Error)
}

public final class ReaderPairingViewController: UIViewController {
    private weak var delegate: ReaderPairingViewControllerDelegate?
    private let theme: Theme
    private let readerManager: ReaderManager

    private lazy var pairingHintStackView = makePairingHintStackView()
    private lazy var pairingActivitySpinner = makeActivitySpinner()
    private lazy var pairingStatusLabel = makePairingStatusLabel()
    private lazy var pairingStatusStackView = makePairingStatusStackView()

    private var pairingHandler: PairingHandle?

    public init(theme: Theme, readerManager: ReaderManager, delegate: ReaderPairingViewControllerDelegate) {
        self.theme = theme
        self.readerManager = readerManager
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        title = ReaderSDK2UIStrings.ReaderPairing.title
        preferredContentSize = CGSize(width: 417, height: 409)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelButton

        let pairingHintLayoutGuide = UILayoutGuide()
        view.addLayoutGuide(pairingHintLayoutGuide)

        view.backgroundColor = theme.backgroundColor
        view.addSubview(pairingHintStackView)
        view.addSubview(pairingStatusStackView)

        NSLayoutConstraint.activate([
            pairingHintLayoutGuide.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pairingHintLayoutGuide.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            pairingHintLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pairingHintLayoutGuide.bottomAnchor.constraint(equalTo: pairingStatusStackView.topAnchor),

            pairingHintStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pairingHintStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            pairingHintStackView.centerYAnchor.constraint(equalTo: pairingHintLayoutGuide.centerYAnchor),

            pairingStatusStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            pairingStatusStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            pairingStatusStackView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            pairingStatusStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutMargins = ReaderSDK2UILayout.preferredMargins(view: view)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        pairingHandler = readerManager.startPairing(with: self)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pairingHandler?.stop()
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusBarStyle
    }

    private func updatePairingStatus(with text: String) {
        pairingStatusLabel.text = text
    }
}

// MARK: - SQRDReaderPairingDelegate

extension ReaderPairingViewController: ReaderPairingDelegate {
    public func readerPairingDidBegin() {
        updatePairingStatus(with: ReaderSDK2UIStrings.ReaderPairing.pairingWithReader)
    }

    public func readerPairingDidSucceed() {
        delegate?.readerPairingViewControllerDidFinish(self)
    }

    public func readerPairingDidFail(withError error: Error) {
        delegate?.readerPairingViewController(self, didFailWith: error)
    }
}

// MARK: - Private Methods
private extension ReaderPairingViewController {

    @objc func cancelButtonPressed() {
        delegate?.readerPairingViewControllerDidFinish(self)
    }

    func makePairingHintStackView() -> UIStackView {
        let imageView = makePairingHintImageView()
        let label = makePairingHintLabel()
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = ReaderSDK2UILayout.sectionSpacing
        return stackView
    }

    func makePairingHintImageView() -> UIImageView {
        let pairingHintImageView = UIImage(
            named: "reader-pairing-hint",
            in: .readerSDK2UIResources,
            compatibleWith: nil
        )!

        let imageView = UIImageView(image: pairingHintImageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    func makePairingHintLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ReaderSDK2UIStrings.ReaderPairing.bluetoothPairingInstructions
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = theme.titleColor
        return label
    }

    func makePairingStatusStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [pairingStatusLabel, pairingActivitySpinner])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }

    func makeActivitySpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: theme.tertiaryBackgroundColor.isLightColor ? .gray : .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        return spinner
    }

    func makePairingStatusLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ReaderSDK2UIStrings.ReaderPairing.lookingForReaders
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = theme.subtitleColor
        return label
    }
}
