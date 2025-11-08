//
//  HomeViewController.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 6.11.2025.
//

import Foundation

// MARK: - Example HomeViewController (stub)
import UIKit
final class HomeViewController: UIViewController {
    private let session: UserSession
    init(session: UserSession) { self.session = session; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "Hoş geldin, \(session.email)"
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
