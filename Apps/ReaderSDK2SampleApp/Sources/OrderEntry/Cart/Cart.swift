//
//  Cart.swift
//  ReaderSDK2-SampleApp
//
//  Created by Kevin Leong on 6/7/19.
//

import ReaderSDK2
import ReaderSDK2UI

struct Cart {
    struct Item: Equatable {
        var name: String
        var price: Money
    }

    var currency: Currency

    var items: [Item] {
        if let openItem = openItem {
            return closedItems + [openItem]
        } else {
            return closedItems
        }
    }

    var openItem: Item? {
        didSet {
            if let openItem = openItem, openItem.price.amount == 0 {
                fatalError("Attempting to set a cart's open item to an item with no price.")
            }
        }
    }

    private var closedItems: [Item]

    var total: Money {
        let totalAmount: UInt = items.reduce(0) { total, item in
            guard item.price.currency == currency else {
                fatalError("Expected \(currency.currencyCode), got \(item.price.currency.currencyCode)")
            }

            return total + item.price.amount
        }

        return Money(amount: totalAmount, currency: currency)
    }

    mutating func remove(item: Item) {
        if item == openItem {
            openItem = nil
        } else {
            closedItems.remove(at: closedItems.firstIndex(of: item)!)
        }
    }

    mutating func closeOpenItem() {
        guard let openItem = openItem else {
            fatalError("Attempting to close a non-existent open item")
        }

        self.openItem = nil
        closedItems.append(openItem)
    }

    mutating func resetCart() {
        openItem = nil
        closedItems = [Item]()
    }
}

extension Cart {
    init(currency: Currency) {
        self.init(currency: currency, openItem: nil, closedItems: [])
    }
}

extension Cart: CustomStringConvertible {
    var description: String {
        var text: String

        text = items.reduce(into: "") { result, item in
            result.append("\(item.name): \(item.price.description)\n")
        }

        text.append("\(Strings.OrderEntry.totalAmountDescriptionPrefix) \(total.description))\n")

        return text
    }
}

extension Cart.Item {
    init(customPrice: Money) {
        self.init(name: Strings.OrderEntry.customAmountItemName, price: customPrice)
    }
}
