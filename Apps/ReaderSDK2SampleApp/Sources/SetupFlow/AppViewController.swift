//
//  AppViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/14/19.
//

import ReaderSDK2
import ReaderSDK2UI
import SafariServices
import UIKit

#if canImport(MockReaderUI)
import MockReaderUI
#endif

protocol MockReaderUIPresentationDelegate: AnyObject {
    func toggleMockReaderUI(enabled: Bool)
}

/// AppViewController is the root view controller of the application. It manages transitions between screens.
final class AppViewController: UIViewController {
    private let theme: Theme = Config.theme
    private let authorizationManager: AuthorizationManager
    private let readerManager: ReaderManager
    private let paymentManager: PaymentManager

#if canImport(MockReaderUI)
    private lazy var mockReaderUI: MockReaderUI? = {
        guard ReaderSDK.shared.isSandboxEnvironment else { return nil }

        do {
            return try MockReaderUI(for: ReaderSDK.shared)
        } catch {
            assertionFailure("Could not instantiate a mock reader UI: \(error.localizedDescription)")
        }

        return nil
    }()
#endif

    init(authorizationManager: AuthorizationManager, readerManager: ReaderManager, paymentManager: PaymentManager) {
        self.authorizationManager = authorizationManager
        self.readerManager = readerManager
        self.paymentManager = paymentManager

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDefaultNavigationBarAppearance()

        authorizationManager.add(self)

        showNextViewController()
    }

    override var childForStatusBarStyle: UIViewController? {
        return children.first
    }

    func performAuthorization() -> Void {
        completeAuthorization(withAccessToken: Config.accessToken, locationID: Config.locationID)
    }

    func completeAuthorization(withAccessToken accessToken: String, locationID: String) {
        // Show "Authorizing..." below the safari view controller
        showAuthorizingViewController()

        // Dismiss the safari view controller
        dismiss(animated: true, completion: nil)

        authorizationManager.authorize(withAccessToken: accessToken, locationID: locationID) { [weak self] error in
            print("Authorization State: \(self?.authorizationManager.state.description ?? "")")

            guard let error = error else {
                return
            }

            self?.showAuthorizationError(error)
        }
    }

    private func showAuthorizationError(_ error: Error) {
        let alert = UIAlertController(title: Strings.Authorization.errorTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Authorization.errorDismissButtonTitle, style: .default, handler: { [weak self] _ in
            self?.showStartViewController(transition: .pop)
        }))
        present(alert, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorGenerator.statusBarStyle(theme: theme)
    }
}

// MARK: - Screen Transitions
extension AppViewController {

    func showNextViewController() {
        if !PermissionsViewController.areAllRequiredPermissionsGranted {
            showPermissionsViewController()
            return
        }

        if authorizationManager.state != .authorized {
            showStartViewController()
            return
        }

        showLoggedInViewController()
    }

    func showStartViewController(transition style: TransitionStyle = .push) {
        let viewController = StartViewController(theme: theme, delegate: self)
        transition(to: viewController, style: style)
    }

    func showOAuthFlow(with oauthURL: URL) {
        let oauthFlow = SFSafariViewController(url: oauthURL)
        oauthFlow.dismissButtonStyle = .cancel
        present(oauthFlow, animated: true, completion: nil)
    }

    func showAuthorizingViewController(transition style: TransitionStyle = .push) {
        let viewController = LoadingViewController(theme: theme, title: Strings.Authorization.inProgress)
        transition(to: viewController, style: style)
    }

    func showPermissionsViewController(transition style: TransitionStyle = .pop) {
        let viewController = PermissionsViewController(theme: theme, delegate: self)
        let navigationController = UINavigationController(rootViewController: viewController)
        transition(to: navigationController, style: style)
    }

    func showLoggedInViewController(transition style: TransitionStyle = .push) {
        let viewController = LoggedInViewController(theme: theme, authorizationManager: authorizationManager, readerManager: readerManager, paymentManager: paymentManager, delegate: self)
        transition(to: viewController, style: style)

        toggleMockReaderUI(enabled: true)
    }

    func transition(to nextViewController: UIViewController, style: TransitionStyle) {
        guard let currentViewController = children.first else {
            addInitialChildViewController(nextViewController)
            return
        }

        // Position the nextViewController offscreen and animate it into place.
        addChild(nextViewController)
        view.addSubview(nextViewController.view)
        let offsetX = (style == .push) ? view.bounds.width : -view.bounds.width
        nextViewController.view.frame = view.bounds.offsetBy(dx: offsetX, dy: 0)

        // Notify the current view controller that it will be removed.
        currentViewController.willMove(toParent: nil)

        let animations = {
            currentViewController.view.frame = self.view.bounds.offsetBy(dx: -offsetX, dy: 0)
            nextViewController.view.frame = self.view.bounds
        }
        let completion: (Bool) -> Void = { _ in
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParent()
            nextViewController.didMove(toParent: self)
            self.setNeedsStatusBarAppearanceUpdate()
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [],
            animations: animations,
            completion: completion
        )
    }

    func addInitialChildViewController(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
        setNeedsStatusBarAppearanceUpdate()
    }

    enum TransitionStyle {
        case push, pop
    }
}

// MARK: - StartViewControllerDelegate
extension AppViewController: StartViewControllerDelegate {

    func startViewControllerDidInitiateAuthorization(_ startViewController: StartViewController) {
        performAuthorization()
    }
}

// MARK: - PermissionsViewControllerDelegate
extension AppViewController: PermissionsViewControllerDelegate {

    func permissionsViewControllerDidObtainRequiredPermissions(_ permissionsViewController: PermissionsViewController) {
        showNextViewController()
    }
}

// MARK: - MockReaderUIPresentationDelegate
extension AppViewController: MockReaderUIPresentationDelegate {

    func toggleMockReaderUI(enabled: Bool) {
#if canImport(MockReaderUI)
        guard let mockReaderUI = mockReaderUI else { return }

        guard enabled else {
            mockReaderUI.dismiss()
            return
        }

        do {
            try mockReaderUI.present()
        } catch {
            // The state _must_ be authorized for presentation to occur.
            assertionFailure(error.localizedDescription)
        }
#endif
    }
}

// MARK: - LoggedInViewControllerDelegate
extension AppViewController: LoggedInViewControllerDelegate {

    func loggedInViewControllerDidInitiateLogout(_ loggedInViewController: LoggedInViewController) {
        authorizationManager.deauthorize()
    }
}

extension AppViewController: AuthorizationStateObserver {
    func authorizationStateDidChange(_ authorizationState: AuthorizationState) {
        showNextViewController()
    }
}

// MARK: - Private Methods
private extension AppViewController {
    func configureDefaultNavigationBarAppearance() {

        let barAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 19, weight: .black),
            .foregroundColor: theme.titleColor,
        ]

        let barButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: theme.tintColor,
        ]

        UINavigationBar.appearance().barStyle = ColorGenerator.barStyle(theme: theme)

        UINavigationBar.appearance().titleTextAttributes = barAttributes
        UINavigationBar.appearance().barTintColor = ColorGenerator.tertiaryBackgroundColor(theme: theme)
        UINavigationBar.appearance().tintColor = theme.tintColor
        UIBarButtonItem.appearance().setTitleTextAttributes(
            barButtonAttributes,
            for: .normal
        )
        UIBarButtonItem.appearance().setTitleTextAttributes(
            barButtonAttributes,
            for: .highlighted
        )
    }
}
