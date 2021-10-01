//
//  StartViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/14/19.
//

import ReaderSDK2
import UIKit

protocol StartViewControllerDelegate: AnyObject {
    func startViewControllerDidInitiateAuthorization(_ startViewController: StartViewController)
}

final class StartViewController: UIViewController {
    private lazy var backgroundGradientLayer = makeBackgroundGradientLayer()
    private lazy var headerImageView = makeHeaderImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var loginButton = makeLoginButton()
    private let theme: Theme

    private weak var delegate: StartViewControllerDelegate?

    init(theme: Theme, delegate: StartViewControllerDelegate) {
        self.theme = theme
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(backgroundGradientLayer)
        view.addSubview(headerImageView)
        view.addSubview(titleLabel)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            // headerImageView
            headerImageView.widthAnchor.constraint(equalToConstant: 40),
            headerImageView.heightAnchor.constraint(equalToConstant: 40),
            headerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            // loginButton
            loginButton.widthAnchor.constraint(equalToConstant: 220),
            loginButton.heightAnchor.constraint(equalToConstant: 64),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
        additionalSafeAreaInsets = UIEdgeInsets(top: view.bounds.height * 0.17, left: 0, bottom: 48, right: 0)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Private Methods
private extension StartViewController {

    func makeBackgroundGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [#colorLiteral(red: 0.09019607843, green: 0.1215686275, blue: 0.1294117647, alpha: 1).cgColor, #colorLiteral(red: 0.04705882353, green: 0.06666666667, blue: 0.07058823529, alpha: 1).cgColor]
        return layer
    }

    func makeHeaderImageView() -> UIImageView {
        let image = UIImage(named: "square-logo", in: .r2SampleAppResources, compatibleWith: nil)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.Start.title
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        return label
    }

    func makeLoginButton() -> Button {
        let button = Button(theme: theme)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.Start.loginButtonTitle, for: [])
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }

    @objc func loginButtonPressed() {
        delegate?.startViewControllerDidInitiateAuthorization(self)
    }
}
