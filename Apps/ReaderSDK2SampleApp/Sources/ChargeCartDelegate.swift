//
//  ChargeCartDelegate.swift
//  ReaderSDK2-SampleApp
//
//  Created by Mike Silvis on 10/2/19.
//

import Foundation
import ReaderSDK2

protocol ChargeCartDelegate: AnyObject {
    func charge(total: Money)
}
