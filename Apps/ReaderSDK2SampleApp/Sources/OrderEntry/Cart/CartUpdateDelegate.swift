//
//  CartUpdateDelegate.swift
//  ReaderSDK2-SampleApp
//
//  Created by Mike Silvis on 9/25/19.
//

import Foundation

protocol CartUpdateDelegate: AnyObject {
    func didRemoveItemFromCart(updatedCart: Cart)
    func closeOpenItem()
    func didUpdate(openItem: Cart.Item?)
}
