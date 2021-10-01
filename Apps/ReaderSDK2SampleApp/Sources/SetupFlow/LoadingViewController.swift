//
//  LoadingViewController.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/14/19.
//

import ReaderSDK2
import UIKit

final class LoadingViewController: UIViewController {
    lazy var activityIndicator = makeActivityIndicator()
    lazy var titleLabel = makeTitleLabel()
    lazy var stackView = makeStackView()
    private let theme: Theme

    init(theme: Theme, title: String) {
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.backgroundColor
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.stopAnimating()
    }
}

// MARK: - Private Methods
private extension LoadingViewController {

    func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = theme.tintColor
        return activityIndicator
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = theme.titleColor
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [activityIndicator, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }
}
