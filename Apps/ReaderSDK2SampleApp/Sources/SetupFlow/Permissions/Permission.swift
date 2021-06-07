//
//  Permission.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/18/19.
//

import Foundation

protocol Permission {
    var prompt: String { get }
    var reason: String { get }
    var status: PermissionStatus { get }
    func requestFromUser(completion: @escaping () -> Void)
}

enum PermissionStatus {
    case notDetermined
    case granted
    case denied
    case restricted
}
