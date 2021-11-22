//
//  BluetoothPermission.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 9/24/19.
//

import CoreBluetooth

@available(iOS 13.1, *)
final class BluetoothPermission: NSObject, Permission {
    private var centralManager: CBCentralManager?
    private var requestPermissionCompletion: (() -> Void)?

    let prompt = Strings.Permissions.bluetoothPrompt

    var reason: String {
        return Bundle.main.object(forInfoDictionaryKey: "NSBluetoothAlwaysUsageDescription") as! String
    }

    var status: PermissionStatus {
        return PermissionStatus(CBManager.authorization)
    }

    func requestFromUser(completion: @escaping () -> Void) {
        guard status == .notDetermined else {
            completion()
            return
        }
        // Initializing CBCentralManager results in a prompt asking the user to grant access if the status is `.notDetermined`.
        // `centralManagerDidUpdateState:` will be called once the user has granted permission.
        requestPermissionCompletion = completion
        centralManager = CBCentralManager(delegate: self, queue: .main, options: nil)
    }
}

@available(iOS 13.1, *)
extension BluetoothPermission: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.authorization != .notDetermined {
            requestPermissionCompletion?()
            requestPermissionCompletion = nil
        }
    }
}

@available(iOS 13.1, *)
private extension PermissionStatus {

    init(_ bluetoothAuthorization: CBManagerAuthorization) {
        switch bluetoothAuthorization {
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .allowedAlways: self = .granted

        case .notDetermined: fallthrough
        @unknown default: self = .notDetermined
        }
    }
}
