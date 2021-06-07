//
//  KeypadViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by Mike Silvis on 9/25/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class KeypadViewController: UIViewController {
    var cart: Cart {
        didSet {
            cartButton.cart = cart
            chargeButton.cartTotal = cart.total
            cartViewController?.cart = cart
            customAmountEntryView.openItem = cart.openItem
        }
    }

    private let theme: Theme

    weak var cartUpdateDelegate: CartUpdateDelegate? {
        didSet {
            customAmountEntryView.cartUpdateDelegate = cartUpdateDelegate
        }
    }

    private weak var chargeCartDelegate: ChargeCartDelegate?

    private lazy var stackView = makeContainerStackView()
    private lazy var cartButton = makeCartButton(theme: theme, cart: cart)
    private lazy var chargeButton = makeChargeButton(theme: theme, cart: cart)
    private(set) lazy var customAmountEntryView = makeCustomAmountEntryView(theme: theme, cart: cart)
    private lazy var checkoutStackView = makeCheckoutStackView()
    private lazy var trailingHairlineView = makeHairlineView(orientation: .vertical)

    private var cartViewController: CartViewController?

    private var isSplitViewControllerCollapsed: Bool {
        return splitViewController?.isCollapsed ?? true
    }

    // Margins bleed differently based on the layouts
    private var backgroundColor: UIColor {
        return isSplitViewControllerCollapsed ? ColorGenerator.tertiaryBackgroundColor(theme: theme) : ColorGenerator.secondaryBackgroundColor(theme: theme)
    }

    init(theme: Theme, cart: Cart, chargeCartDelegate: ChargeCartDelegate) {
        self.theme = theme
        self.cart = cart
        self.chargeCartDelegate = chargeCartDelegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupSubviews() {
        view.addSubview(stackView)
        view.addSubview(trailingHairlineView)

        stackView.pinToEdges(of: view.safeAreaLayoutGuide)

        checkoutStackView.addArrangedSubview(cartButton)

        let chargeButtonStackView = makeChargeButtonStackview()
        chargeButtonStackView.addArrangedSubview(chargeButton)
        checkoutStackView.addArrangedSubview(chargeButtonStackView)

        checkoutStackView.addArrangedSubview(makeHairlineView(orientation: .horizontal))

        stackView.addArrangedSubview(checkoutStackView)
        stackView.addArrangedSubview(customAmountEntryView)

        NSLayoutConstraint.activate([
            trailingHairlineView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trailingHairlineView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            trailingHairlineView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        checkoutStackView.isHidden = !isSplitViewControllerCollapsed
        trailingHairlineView.isHidden = isSplitViewControllerCollapsed

        view.backgroundColor = backgroundColor
    }

    override func becomeFirstResponder() -> Bool {
        return customAmountEntryView.becomeFirstResponder()
    }
}

extension KeypadViewController {
    private func makeCustomAmountEntryView(theme: Theme, cart: Cart) -> CustomAmountEntryView {
        let view = CustomAmountEntryView(theme: theme, openItem: cart.openItem, currency: cart.currency)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    private func makeContainerStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }

    private func makeCheckoutStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = orderEntryDefaultMargin
        stackView.setBackground(color: ColorGenerator.tertiaryBackgroundColor(theme: theme))
        stackView.layoutMargins = UIEdgeInsets(
            top: orderEntryDefaultMargin,
            left: 0,
            bottom: 0,
            right: 0
        )

        return stackView
    }

    func makeChargeButton(theme: Theme, cart: Cart) -> ChargeButton {
        let button = ChargeButton(theme: theme, cartTotal: cart.total)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapChargeButton), for: .touchUpInside)

        return button
    }

    func makeChargeButtonStackview() -> UIStackView {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: orderEntryDefaultMargin,
            bottom: 0,
            right: orderEntryDefaultMargin
        )

        return stackView
    }

    private func makeCartButton(theme: Theme, cart: Cart) -> CartButton {
        let button = CartButton(theme: theme, cart: cart)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)

        return button
    }

    func makeHairlineView(orientation: HairlineView.Orientation) -> HairlineView {
        let view = HairlineView(theme: theme, orientation: orientation)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    @objc func didTapChargeButton() {
        chargeCartDelegate?.charge(total: cart.total)
    }

    @objc func didTapCartButton() {
        present(makeCartNavigationViewController(), animated: true, completion: nil)
    }

    func makeCartViewController() -> CartViewController {
        return CartViewController(theme: theme, cart: cart, chargeCartDelegate: chargeCartDelegate!)
    }

    func makeCartNavigationViewController() -> UINavigationController {
        cartViewController = makeCartViewController()

        let image = UIImage(named: "cancel-button", in: .r2SampleAppResources, compatibleWith: nil)
        let cancelButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapCartDismiss))
        cartViewController!.navigationItem.leftBarButtonItem = cancelButton

        return UINavigationController(rootViewController: cartViewController!)
    }

    @objc func didTapCartDismiss() {
        dismiss(animated: true) {
            self.cartViewController = nil
        }
    }
}
