//
//  CartView.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/14/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

class CartView: UIView {
    var cartUpdateDelegate: CartUpdateDelegate?

    private lazy var emptyCartLabel = makeEmptyCartLabel()
    private lazy var itemsTableView = makeItemsTableView()
    private lazy var totalLineItemView = makeTotalLineItemView()
    private lazy var itemsTableViewMaxHeightConstraint = makeItemsTableViewMaxHeightConstraint()

    var cart: Cart {
        didSet {
            displayAndHideElementsBasedOnCartContents()
            itemsTableView.reloadData()
            totalLineItemView.amountText = cart.total.description
            setNeedsLayout()
        }
    }

    private var lineItemFontSize: CGFloat = 16
    private let theme: Theme

    init(theme: Theme, cart: Cart) {
        self.theme = theme
        self.cart = cart

        super.init(frame: .zero)

        addSubview(emptyCartLabel)
        addSubview(itemsTableView)
        addSubview(totalLineItemView)

        displayAndHideElementsBasedOnCartContents()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        itemsTableViewMaxHeightConstraint.constant = itemsTableView.contentSize.height
    }
}

// MARK: - UITableViewDataSource
extension CartView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.self.description(), for: indexPath) as? CartTableViewCell else {
            fatalError("Unexpected UITableViewCell class. Expected \(CartTableViewCell.self.description())")
        }

        let item = cart.items[indexPath.row]

        cell.lineItemFont = UIFont.systemFont(ofSize: lineItemFontSize)
        cell.lineItemView.title = item.name
        cell.lineItemView.amountText = item.price.description
        cell.theme = theme

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, complete in

            self.cart.remove(item: self.cart.items[indexPath.row])
            self.cartUpdateDelegate?.didRemoveItemFromCart(updatedCart: self.cart)

            complete(true)
        }

        let image = UIImage(named: "trash-can", in: .r2SampleAppResources, compatibleWith: nil)
        deleteAction.image = image

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

private extension CartView {
    // MARK: - Layout

    func setupConstraints() {
        // Must use a non-zero min height, and CGFloat.leastNonZeroMagnitude doesn't work.
        let itemsTableViewMinHeightConstraint = itemsTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.01)

        NSLayoutConstraint.activate([
            // Empty cart label
            emptyCartLabel.topAnchor.constraint(equalTo: topAnchor, constant: lineItemFontSize * 2),
            emptyCartLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyCartLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),

            // Items table view
            itemsTableViewMaxHeightConstraint,
            itemsTableViewMinHeightConstraint,
            itemsTableView.widthAnchor.constraint(equalTo: widthAnchor),
            itemsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemsTableView.topAnchor.constraint(equalTo: topAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: totalLineItemView.topAnchor, constant: -orderEntryDefaultMargin),

            // Total Label
            totalLineItemView.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalLineItemView.widthAnchor.constraint(equalTo: widthAnchor),
            totalLineItemView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func displayAndHideElementsBasedOnCartContents() {
        let isCartEmpty = cart.items.count == 0
        emptyCartLabel.isHidden = !isCartEmpty
        itemsTableView.isHidden = isCartEmpty
        totalLineItemView.isHidden = isCartEmpty
    }

    // MARK: - Factories

    func makeEmptyCartLabel() -> UILabel {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The cart is empty."
        label.textColor = theme.subtitleColor
        label.font = UIFont.systemFont(ofSize: lineItemFontSize)

        return label
    }

    func makeItemsTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets.zero

        addBorderWithRoundedCorners(to: tableView)

        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.self.description())
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }

    func makeTotalLineItemView() -> CartLineItemView {
        let view = CartLineItemView(theme: theme)

        view.title = Strings.OrderEntry.cartTotal
        view.amountText = cart.total.description
        view.font = UIFont.boldSystemFont(ofSize: lineItemFontSize)
        view.theme = theme
        view.translatesAutoresizingMaskIntoConstraints = false
        addBorderWithRoundedCorners(to: view)

        return view
    }

    func makeItemsTableViewMaxHeightConstraint() -> NSLayoutConstraint {
        let constraint = itemsTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 1)
        constraint.priority = .defaultLow
        return constraint
    }

    func addBorderWithRoundedCorners(to view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = theme.titleColor.cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }
}
