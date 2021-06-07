//
//  CartViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/17/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class CartViewController: UIViewController {
    private lazy var chargeButton = makeChargeButton()

    private var isSplitViewControllerCollapsed: Bool {
        return splitViewController?.isCollapsed ?? true
    }

    var cart: Cart {
        didSet {
            cartView.cart = cart
            chargeButton.cartTotal = cart.total
        }
    }

    weak var cartUpdateDelegate: CartUpdateDelegate? {
        didSet {
            cartView.cartUpdateDelegate = cartUpdateDelegate
        }
    }

    private weak var chargeCartDelegate: ChargeCartDelegate?

    private lazy var cartView = makeCartView()
    private let theme: Theme

    init(theme: Theme, cart: Cart, chargeCartDelegate: ChargeCartDelegate) {
        self.theme = theme
        self.cart = cart
        self.chargeCartDelegate = chargeCartDelegate

        super.init(nibName: nil, bundle: nil)

        title = Strings.OrderEntry.cartTitle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)

        view.addSubview(cartView)
        view.addSubview(chargeButton)

        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.layoutMargins = ReaderSDK2UILayout.preferredMargins(view: view)

        reload()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        reload()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        reload()
    }

    private func reload() {
        chargeButton.isHidden = isSplitViewControllerCollapsed
    }
}

private extension CartViewController {
    // MARK: - Layout

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Cart View
            cartView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            cartView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            cartView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cartView.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),

            // Charge Button
            chargeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -orderEntryDefaultMargin),
            chargeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: orderEntryDefaultMargin),
            chargeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -orderEntryDefaultMargin),
        ])
    }

    // MARK: - Factories

    func makeCartView() -> CartView {
        let view = CartView(theme: theme, cart: cart)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    func makeChargeButton() -> ChargeButton {
        let button = ChargeButton(theme: theme, cartTotal: cart.total)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapChargeButton), for: .touchUpInside)
        return button
    }

    @objc func didTapChargeButton() {
        chargeCartDelegate?.charge(total: cart.total)
    }
}
