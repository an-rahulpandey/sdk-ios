//
//  PermissionsViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/18/19.
//

import ReaderSDK2
import ReaderSDK2UI
import UIKit

protocol PermissionsViewControllerDelegate: AnyObject {
    func permissionsViewControllerDidObtainRequiredPermissions(_ permissionsViewController: PermissionsViewController)
}

final class PermissionsViewController: UIViewController {
    private weak var delegate: PermissionsViewControllerDelegate?
    private lazy var stackView = makeStackView()
    private lazy var doneButton = makeDoneButton()
    private lazy var permissionViews = makePermissionViews()
    private let theme: Theme

    init(theme: Theme, delegate: PermissionsViewControllerDelegate) {
        self.theme = theme
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        title = Strings.Permissions.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorGenerator.secondaryBackgroundColor(theme: theme)

        // Add permission views with separators
        permissionViews
            .flatMap { [$0, makeSeparator()] }.dropLast()
            .forEach(stackView.addArrangedSubview)

        view.addSubview(stackView)

        let stackViewTopBorder = makeSeparator()
        let stackViewBottomBorder = makeSeparator()
        view.addSubview(stackViewTopBorder)
        view.addSubview(stackViewBottomBorder)
        view.addSubview(doneButton)

        reloadViews()

        NSLayoutConstraint.activate([
            // Stack view
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // Top border
            stackViewTopBorder.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            stackViewTopBorder.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            stackViewTopBorder.bottomAnchor.constraint(equalTo: stackView.topAnchor),

            // Bottom border
            stackViewBottomBorder.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            stackViewBottomBorder.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            stackViewBottomBorder.topAnchor.constraint(equalTo: stackView.layoutMarginsGuide.bottomAnchor),

            // Done button
            doneButton.topAnchor.constraint(equalTo: stackViewBottomBorder.bottomAnchor, constant: ReaderSDK2UILayout.sectionSpacing),
            doneButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])

        // Reload views when app gets foregrounded in case permissions were changed in Settings.app
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutMargins = ReaderSDK2UILayout.preferredMargins(view: view)
    }

    static var areAllRequiredPermissionsGranted: Bool {
        // Bluetooth is not included here since we can't determine its status without incidentally requesting access from the user.
        return (MicrophonePermission().status == .granted) && (LocationPermission().status == .granted)
    }
}

// MARK: - PermissionViewDelegate
extension PermissionsViewController: PermissionViewDelegate {

    func permissionView(_ permissionView: PermissionView, didTap permission: Permission) {
        switch permission.status {
        case .notDetermined:
            permission.requestFromUser { [weak self] in
                self?.reloadViews()
            }
        case .denied, .restricted:
            openSettingsApp()
        case .granted:
            reloadViews()
        }
    }
}

// MARK: - Private Methods
private extension PermissionsViewController {

    @objc func reloadViews() {
        for permissionView in permissionViews {
            permissionView.reloadCheckmark()
        }
        doneButton.isEnabled = permissionViews.allSatisfy { $0.permission.status == .granted }
    }

    func openSettingsApp() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func makePermissionViews() -> [PermissionView] {
        var permissions: [Permission] = [MicrophonePermission(), LocationPermission()]

        if #available(iOS 13.1, *) {
            permissions.append(BluetoothPermission())
        }

        return permissions.map { PermissionView(theme: theme, permission: $0, delegate: self) }
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        stackView.setBackground(color: ColorGenerator.tertiaryBackgroundColor(theme: theme))
        return stackView
    }

    func makeDoneButton() -> Button {
        let button = Button(theme: theme)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.Permissions.doneButtonTitle, for: [])
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }

    func makeSeparator() -> UIView {
        let view = HairlineView(theme: theme)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    @objc func doneButtonPressed() {
        delegate?.permissionsViewControllerDidObtainRequiredPermissions(self)
    }
}
