//
//  LoginViewController.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation


// MARK: - Modules/Auth/Login/View/LoginViewController.swift
import UIKit
import SnapKit
import Then
import AuthenticationServices

final class LoginViewController: UIViewController, LoginViewProtocol {
    ///VIPER bağlantısı. View yalnızca Presenter protokolünü bilir; iş mantığı yok.
    ///Not: VC, Presenter’ı strong tutar; Presenter View’u weak tutar → retain cycle olmaz.
    var presenter: LoginPresenterProtocol!

    private let titleLabel = UILabel().then {
        $0.text = "Giriş"
        $0.font = .boldSystemFont(ofSize: 28)
        $0.textAlignment = .center
    }

    private let emailField = UITextField().then {
        $0.placeholder = "E‑posta"
        $0.autocapitalizationType = .none
        $0.keyboardType = .emailAddress
        $0.borderStyle = .roundedRect
    }

    private let passwordField = UITextField().then {
        $0.placeholder = "Şifre"
        $0.isSecureTextEntry = true
        $0.borderStyle = .roundedRect
    }

    private let loginButton = UIButton(type: .system).then {
        $0.setTitle("Giriş Yap", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
    }

    private let registerButton = UIButton(type: .system).then {
        $0.setTitle("Kayıt Ol", for: .normal)
    }

    private let forgotButton = UIButton(type: .system).then {
        $0.setTitle("Şifremi Unuttum", for: .normal)
    }
    
    // ✅ Apple butonu (dark/light mod otomatik)
    private let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)

    private let activity = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        bind()
        presenter.onViewDidLoad()
    }

    private func layout() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, emailField, passwordField, loginButton, registerButton, forgotButton,appleButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill

        view.addSubview(stack)
        view.addSubview(activity)

        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview().priority(.low)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true // ✅
    }

    private func bind() {
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(onForgot), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(onAppleLogin), for: .touchUpInside)
       
    }

    @objc private func onLogin() {
        presenter.didTapLogin(email: emailField.text, password: passwordField.text)
    }

    @objc private func onRegister() {
        presenter.didTapRegister(email: emailField.text, password: passwordField.text)
    }

    @objc private func onForgot() {
        presenter.didTapForgotPassword(email: emailField.text)
    }
    
    @objc private func onAppleLogin() {
        presenter.didTapAppleLogin()
    }
    // MARK: - LoginViewProtocol
    func render(state: LoginViewState) {
        switch state {
        case .idle:
            activity.stopAnimating()
        case .loading(let isLoading):
            isLoading ? activity.startAnimating() : activity.stopAnimating()
            view.isUserInteractionEnabled = !isLoading
        case .error(let message):
            activity.stopAnimating()
            let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
        }
    }
}

