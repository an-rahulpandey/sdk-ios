//
//  AppDelegate.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/14/19.
//

import ReaderSDK2
import UIKit

public final class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    private lazy var appViewController = makeAppViewController(readerSDK: ReaderSDK.shared)

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        ReaderSDK.initialize(applicationLaunchOptions: launchOptions, squareApplicationID: Config.squareApplicationID)

        // Use a local var to avoid unwrapping
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = appViewController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let accessToken = urlComponents.queryItem(named: "access_token"),
            let locationID = urlComponents.queryItem(named: "location_id")
        else {
                return false
        }
        appViewController.completeAuthorization(withAccessToken: accessToken, locationID: locationID)
        return true
    }
}

private extension AppDelegate {
    func makeAppViewController(readerSDK: SDKManager) -> AppViewController {
        return AppViewController(
            authorizationManager: readerSDK.authorizationManager,
            readerManager: readerSDK.readerManager,
            paymentManager: readerSDK.paymentManager
        )
    }
}

private extension URLComponents {
    func queryItem(named name: String) -> String? {
        return queryItems?.first(where: { item in item.name == name })?.value
    }
}
