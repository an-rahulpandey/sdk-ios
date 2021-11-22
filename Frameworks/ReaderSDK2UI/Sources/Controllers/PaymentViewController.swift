//
//  PaymentViewController.swift
//  ReaderSDK2UI
//
//  Created by James Smith on 6/18/19.
//

import ReaderSDK2
import UIKit

/// Prompts the user to pay via the available card entry methods.
/// Starting the payment through the PaymentManager's `startPayment(_:theme:from:delegate:)` method is done in `viewDidLoad()`.
public final class PaymentViewController: UIViewController {
    private let parameters: PaymentParameters
    private let paymentManager: PaymentManager
    private let theme: Theme

    private lazy var cancelButton = makeCancelButton()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var amountLabel = makeAmountLabel()
    private lazy var imageView = makeImageView()
    private lazy var promptLabel = makePromptLabel()
    private lazy var manualCardEntryButton = makeManualCardEntryButton()
    private lazy var cardOnFilePaymentButton = makeCardOnFilePaymentButton()

    private var paymentHandle: PaymentHandle?
    private weak var delegate: PaymentManagerDelegate?

    public var availableCardInputMethods: CardInputMethods = CardInputMethods() {
        didSet { availableCardInputMethodsDidChange(from: oldValue, to: availableCardInputMethods) }
    }

    /// When a value for both `cardID` and `PaymentParameters.customerID` are present
    /// the button to charge the customer's card on file will be shown.
    public var cardID: String? {
        didSet {
            cardOnFilePaymentButton.isVisible = cardID != nil && parameters.customerID != nil
        }
    }

    public init(
        parameters: PaymentParameters,
        paymentManager: PaymentManager,
        theme: Theme,
        delegate: PaymentManagerDelegate
    ) {
        self.parameters = parameters
        self.paymentManager = paymentManager
        self.theme = theme
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        paymentManager.remove(self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = theme.secondaryBackgroundColor
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)

        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(amountLabel)
        view.addSubview(imageView)
        view.addSubview(promptLabel)
        view.addSubview(manualCardEntryButton)
        view.addSubview(cardOnFilePaymentButton)
        setupConstraints()

        availableCardInputMethods = paymentManager.availableCardInputMethods
        paymentManager.add(self)

        paymentHandle = paymentManager.startPayment(
            parameters,
            theme: theme,
            from: self,
            delegate: self
        )
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusBarStyle
    }

}

extension PaymentViewController: PaymentManagerDelegate {
    public func paymentManager(_ paymentManager: PaymentManager, didStart payment: Payment) {
        delegate?.paymentManager?(paymentManager, didStart: payment)
    }

    public func paymentManager(_ paymentManager: PaymentManager, didFinish payment: Payment) {
        delegate?.paymentManager(paymentManager, didFinish: payment)
    }

    public func paymentManager(_ paymentManager: PaymentManager, didFail payment: Payment, withError error: Error) {
        delegate?.paymentManager(paymentManager, didFail: payment, withError: error)
    }

    public func paymentManager(_ paymentManager: PaymentManager, didCancel payment: Payment) {
        delegate?.paymentManager(paymentManager, didCancel: payment)
    }

    public func paymentManager(_ paymentManager: PaymentManager, willFinish payment: Payment) {
        delegate?.paymentManager?(paymentManager, willFinish: payment)
    }

    public func paymentManager(_ paymentManager: PaymentManager, willCancel payment: Payment) {
        delegate?.paymentManager?(paymentManager, willCancel: payment)
    }
}

// MARK: - AvailableCardInputMethodsObserver
extension PaymentViewController: AvailableCardInputMethodsObserver {

    public func availableCardInputMethodsDidChange(_ cardInputMethods: CardInputMethods) {
        self.availableCardInputMethods = cardInputMethods
    }
}

// MARK: - Helpers
private extension PaymentViewController {

    func availableCardInputMethodsDidChange(from oldCardInputMethods: CardInputMethods, to newCardInputMethods: CardInputMethods) {
        if newCardInputMethods.isEmpty {
            imageView.image = oldCardInputMethods.disconnectedImage
        } else {
            imageView.image = newCardInputMethods.connectedImage
        }
        promptLabel.text = newCardInputMethods.prompt
    }

    func makeCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = theme.tintColor

        let cancelButtonImage = UIImage(
            named: "cancel-button",
            in: .readerSDK2UIResources,
            compatibleWith: nil
        )!

        button.setImage(cancelButtonImage, for: [])
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }

    @objc func cancelButtonPressed() {
        paymentHandle?.cancelPayment()
    }

    func makeManualCardEntryButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = theme.tintColor
        button.setTitle(ReaderSDK2UIStrings.Pay.manualCardEntry, for: .normal)
        button.addTarget(self, action: #selector(manualCardEntryButtonPressed), for: .touchUpInside)
        return button
    }

    @objc func manualCardEntryButtonPressed() {
        paymentHandle?.enterManually()
    }

    func makeCardOnFilePaymentButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = theme.tintColor
        button.setTitle(ReaderSDK2UIStrings.Pay.cardOnFilePayment, for: .normal)
        button.addTarget(self, action: #selector(cardOnFilePaymentPressed), for: .touchUpInside)
        return button
    }

    @objc func cardOnFilePaymentPressed() {
        guard let cardID = cardID else {
            fatalError("Attempting to create card on file payment without a value set for cardID.")
        }

        paymentHandle?.chargeCardOnFile(cardID: cardID)
    }

    func makeTitleLabel() -> UILabel {
        let label = makeLabel(font: .systemFont(ofSize: 16, weight: .black), color: theme.titleColor)
        label.text = ReaderSDK2UIStrings.Pay.totalAmountHeader
        return label
    }

    func makeAmountLabel() -> UILabel {
        let label = makeLabel(font: .systemFont(ofSize: 40, weight: .black), color: theme.subtitleColor)
        label.text = parameters.totalMoney.description
        return label
    }

    func makePromptLabel() -> UILabel {
        return makeLabel(font: .systemFont(ofSize: 22, weight: .black), color: theme.titleColor)
    }

    func makeLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = font
        label.textColor = color
        return label
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = theme.titleColor
        return imageView
    }

    func setupConstraints() {
        // Contains cancelButton and titleLabel
        let headerLayoutGuide = UILayoutGuide()

        // Contains imageView and promptLabel
        let contentLayoutGuide = UILayoutGuide()

        view.addLayoutGuide(headerLayoutGuide)
        view.addLayoutGuide(contentLayoutGuide)

        NSLayoutConstraint.activate([
            headerLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            headerLayoutGuide.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            headerLayoutGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: 56.0),

            cancelButton.leadingAnchor.constraint(equalTo: headerLayoutGuide.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: headerLayoutGuide.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: headerLayoutGuide.bottomAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: headerLayoutGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerLayoutGuide.centerYAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: headerLayoutGuide.widthAnchor),

            amountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            amountLabel.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor),
            amountLabel.topAnchor.constraint(equalTo: headerLayoutGuide.bottomAnchor),

            contentLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentLayoutGuide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentLayoutGuide.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),

            imageView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),

            promptLabel.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            promptLabel.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            promptLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            promptLabel.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),

            manualCardEntryButton.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            manualCardEntryButton.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            manualCardEntryButton.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 16.0),

            cardOnFilePaymentButton.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            cardOnFilePaymentButton.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            cardOnFilePaymentButton.topAnchor.constraint(equalTo: manualCardEntryButton.bottomAnchor, constant: 16.0),
        ])
    }
}

private extension CardInputMethods {

    var connectedImage: UIImage {
        let magstripeImage = UIImage(
            named: "magstripe",
            in: .readerSDK2UIResources,
            compatibleWith: nil
        )!

        let contactlessImage = UIImage(
            named: "contactless-and-chip",
            in: .readerSDK2UIResources,
            compatibleWith: nil
        )!

       return self == .swipe ? magstripeImage : contactlessImage
    }

    var disconnectedImage: UIImage {
        let magstripeDisconnectedImage = UIImage(
            named: "magstripe-disconnected",
            in: .readerSDK2UIResources,
            compatibleWith: nil
        )!

        let contactlessDisconnected = UIImage(
            named: "contactless-and-chip-disconnected",
            in: .readerSDK2UIResources,
            compatibleWith: nil
        )!

        return self == .swipe ? magstripeDisconnectedImage : contactlessDisconnected
    }

    var prompt: String {

        if self == CardInputMethods([.swipe, .chip, .contactless]) {
            return ReaderSDK2UIStrings.Pay.promptWithInputMethods_swipe_chip_contactless
        }

        if self == CardInputMethods([.swipe, .chip]) {
            return ReaderSDK2UIStrings.Pay.promptWithInputMethods_swipe_chip
        }

        if self == CardInputMethods([.chip, .contactless]) {
            return ReaderSDK2UIStrings.Pay.promptWithInputMethods_chip_contactless
        }

        if self == CardInputMethods([.swipe]) {
            return ReaderSDK2UIStrings.Pay.promptWithInputMethods_swipe
        }

        if self == CardInputMethods([.chip]) {
            return ReaderSDK2UIStrings.Pay.promptWithInputMethods_chip
        }

        return ReaderSDK2UIStrings.Pay.promptWithNoReadersConnected
    }
}
