//
//  OrderEntrySplitViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by Mike Silvis on 9/25/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

protocol OrderEntrySplitViewControllerDelegate: AnyObject {
    func orderEntrySplitViewControllerDidInitiateLogout(_ orderEntrySplitViewController: OrderEntrySplitViewController)
}

class OrderEntrySplitViewController: UISplitViewController {

    private var cart: Cart {
        didSet {
            cartViewController.cart = cart
            keypadViewController.cart = cart
        }
    }

    private let theme: Theme
    private let authorizationManager: AuthorizationManager
    private let paymentManager: PaymentManager
    private lazy var cartViewController = CartViewController(theme: theme, cart: cart, chargeCartDelegate: self)
    private lazy var keypadViewController = KeypadViewController(theme: theme, cart: cart, chargeCartDelegate: self)
    private weak var orderEntrySplitViewControllerDelegate: OrderEntrySplitViewControllerDelegate?

    init(theme: Theme, authorizationManager: AuthorizationManager, paymentManager: PaymentManager, delegate: OrderEntrySplitViewControllerDelegate) {
        self.theme = theme
        self.authorizationManager = authorizationManager
        self.paymentManager = paymentManager
        self.orderEntrySplitViewControllerDelegate = delegate
        self.cart = OrderEntrySplitViewController.makeEmptyCart(authorizationManager: authorizationManager)

        super.init(nibName: nil, bundle: nil)

        viewControllers = makeViewControllers()

        keypadViewController.cartUpdateDelegate = self
        cartViewController.cartUpdateDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.primaryEdge = .trailing
        self.preferredDisplayMode = .allVisible

        view.backgroundColor = ColorGenerator.secondaryBackgroundColor(theme: theme)

        maximumPrimaryColumnWidth = CGFloat(MAXFLOAT)
        preferredPrimaryColumnWidthFraction = 0.3125

        // Used to work around a UISplitViewController bug where the trailing navigation
        // controller doesn't extend all the way to the bottom.
        edgesForExtendedLayout = .bottom
        extendedLayoutIncludesOpaqueBars = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = keypadViewController.becomeFirstResponder()
    }

    private func makeViewControllers() -> [UIViewController] {
        return [
            UINavigationController(rootViewController: cartViewController),
            keypadViewController,
        ]
    }

    private static func makeEmptyCart(authorizationManager: AuthorizationManager) -> Cart {
        return Cart(currency: authorizationManager.authorizedLocation?.currency ?? .USD)
    }
}

extension OrderEntrySplitViewController: CartUpdateDelegate {
    func closeOpenItem() {
        cart.closeOpenItem()
    }

    func didUpdate(openItem: Cart.Item?) {
        guard cart.openItem != openItem else {
            return
        }

        cart.openItem = openItem
    }

    func didRemoveItemFromCart(updatedCart: Cart) {
        cart = updatedCart

        if cart.openItem == nil {
            // The currently open item has been removed, so reset the entered price.
            keypadViewController.customAmountEntryView.resetEnteredPrice()
        }
    }
}

extension OrderEntrySplitViewController: ChargeCartDelegate {
    func charge(total: Money) {
        let parameters = Config.parameters
        parameters.amountMoney = total

        let navigationController = UINavigationController(
            rootViewController: PaymentViewController(
                parameters: parameters,
                paymentManager: paymentManager,
                theme: theme,
                delegate: self
            )
        )
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - PaymentManagerDelegate

extension OrderEntrySplitViewController: PaymentManagerDelegate {

    func paymentManager(_ paymentManager: PaymentManager, didFinish payment: Payment) {
        guard let presentingNavigationConroller = presentedViewController as? UINavigationController else {
            return
        }

        print("Finished payment with ID: \(payment.id!) status: \(payment.status.description)")

        // Reset the cart
        cart = Cart(currency: cart.currency)
        Config.parameters = PaymentParameters(amountMoney: Money(amount: 0, currency: .USD))

        // Show transaction complete
        let transactionComplete = TransactionCompleteViewController(theme: theme, payment: payment)
        presentingNavigationConroller.setViewControllers([transactionComplete], animated: true)
    }

    func paymentManager(_ paymentManager: PaymentManager, didFail payment: Payment, withError error: Error) {
        switch error {
        case Errors.Payment.notAuthorized:
            dismiss(animated: true, completion: self.showLogoutAlert)
        case Errors.Payment.timedOut:
            dismiss(animated: true, completion: nil)
        default:
            dismiss(animated: true) { self.showErrorAlert(error) }
        }
    }

    func paymentManager(_ paymentManager: PaymentManager, didCancel payment: Payment) {
        dismiss(animated: true, completion: nil)
    }
}

private extension OrderEntrySplitViewController {

    func showLogoutAlert() {
        let alert = UIAlertController(title: "Not Authorized", message: "Please log in again.", preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .default, handler: { _ in
            self.orderEntrySplitViewControllerDelegate?.orderEntrySplitViewControllerDidInitiateLogout(self)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showErrorAlert(_ error: Error) {
        print(error)

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
