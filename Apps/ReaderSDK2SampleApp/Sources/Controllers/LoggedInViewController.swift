//
//  LoggedInViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/15/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

protocol LoggedInViewControllerDelegate: AnyObject {
    func loggedInViewControllerDidInitiateLogout(_ loggedInViewController: LoggedInViewController)
}

final class LoggedInViewController: UITabBarController {
    typealias LoggedInViewAndMockReaderUIDelegate = LoggedInViewControllerDelegate & MockReaderUIPresentationDelegate

    private let theme: Theme
    private let authorizationManager: AuthorizationManager
    private let readerManager: ReaderManager
    private let paymentManager: PaymentManager
    private weak var loggedInViewControllerDelegate: LoggedInViewAndMockReaderUIDelegate?

    init(theme: Theme, authorizationManager: AuthorizationManager, readerManager: ReaderManager, paymentManager: PaymentManager, delegate: LoggedInViewAndMockReaderUIDelegate) {
        self.theme = theme
        self.authorizationManager = authorizationManager
        self.readerManager = readerManager
        self.paymentManager = paymentManager

        self.loggedInViewControllerDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barStyle = ColorGenerator.barStyle(theme: theme)
        tabBar.tintColor = theme.tintColor

        viewControllers = [
            makeOrderEntryViewController(),
            makeReadersViewController(),
            makeSettingsViewController(),
        ]
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorGenerator.statusBarStyle(theme: theme)
    }
}

// MARK: - Private Methods
private extension LoggedInViewController {
    // MARK: - Factories

    func makeOrderEntryViewController() -> OrderEntrySplitViewController {
        let viewController = OrderEntrySplitViewController(theme: theme, authorizationManager: authorizationManager, paymentManager: paymentManager, delegate: self)
        let image = UIImage(named: "keypad-tab", in: .r2SampleAppResources, compatibleWith: nil)
        viewController.tabBarItem = UITabBarItem(title: Strings.TabBar.keypad, image: image, selectedImage: nil)

        return viewController
    }

    func makeSettingsViewController() -> UIViewController {
        let settings = SettingsViewController(theme: theme, authorizationManager: authorizationManager, delegate: self)
        let image = UIImage(named: "settings-tab", in: .r2SampleAppResources, compatibleWith: nil)
        settings.tabBarItem = UITabBarItem(title: Strings.TabBar.settings, image: image, selectedImage: nil)
        return UINavigationController(rootViewController: settings)
    }

    func makeReadersViewController() -> UIViewController {
        let readersViewController = ReadersViewController(theme: theme, readerManager: readerManager)
        let image = UIImage(named: "reader-tab", in: .r2SampleAppResources, compatibleWith: nil)
        readersViewController.tabBarItem = UITabBarItem(title: Strings.TabBar.readers, image: image, selectedImage: nil)
        return UINavigationController(rootViewController: readersViewController)
    }

    @objc func dismissPresentedViewController() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - MockReaderUIPresentationDelegate
extension LoggedInViewController: MockReaderUIPresentationDelegate {

    func toggleMockReaderUI(enabled: Bool) {
        loggedInViewControllerDelegate?.toggleMockReaderUI(enabled: enabled)
    }
}

// MARK: - OrderEntrySplitViewControllerDelegate
extension LoggedInViewController: OrderEntrySplitViewControllerDelegate {

    func orderEntrySplitViewControllerDidInitiateLogout(_ orderEntrySplitViewController: OrderEntrySplitViewController) {
        loggedInViewControllerDelegate?.loggedInViewControllerDidInitiateLogout(self)
    }
}

// MARK: - SettingsViewControllerDelegate
extension LoggedInViewController: SettingsViewControllerDelegate {
    func settingsViewControllerDidInitiateLogout(_ settingsViewController: SettingsViewController) {
        loggedInViewControllerDelegate?.loggedInViewControllerDidInitiateLogout(self)
    }
}
