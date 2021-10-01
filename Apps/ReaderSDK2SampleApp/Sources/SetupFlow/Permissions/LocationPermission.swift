//
//  LocationPermission.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/18/19.
//

import CoreLocation

final class LocationPermission: NSObject, Permission, CLLocationManagerDelegate {
    private var requestPermissionCompletion: (() -> Void)?
    private lazy var locationManager = CLLocationManager()

    let prompt = Strings.Permissions.locationServicesPrompt

    var reason: String {
        return Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") as! String
    }

    var status: PermissionStatus {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return .notDetermined
        case .authorizedAlways, .authorizedWhenInUse:
            return .granted
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        @unknown default:
            fatalError("Permission status could not be determined")
        }
    }

    func requestFromUser(completion: @escaping () -> Void) {
        guard status == .notDetermined else {
            completion()
            return
        }
        requestPermissionCompletion = completion
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestPermissionCompletion?()
    }
}
