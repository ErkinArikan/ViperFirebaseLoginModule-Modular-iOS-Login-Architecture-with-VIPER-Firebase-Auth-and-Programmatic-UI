//
//  LoginPresenter.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation


class LoginPresenter:LoginPresenterProtocol{
    
    
    private weak var view: LoginViewProtocol?
    private let interactor: LoginInteractorProtocol
    private let router: LoginRouterProtocol
    
    init(view: LoginViewProtocol? = nil, interactor: LoginInteractorProtocol, router: LoginRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func onViewDidLoad() {
        view?.render(state: .idle)
    }
    
    func didTapLogin(email: String?, password: String?) {
        guard let (e, p) = validate(email: email, password: password) else { return }
        view?.render(state: .loading(true))
        Task { [weak self] in
            guard let self else { return }
            do {
                let session = try await interactor.signIn(email: e, password: p)
                await MainActor.run {
                    self.view?.render(state: .loading(false))
                    self.router.routeToHome(session: session)
                }
            } catch {
                await MainActor.run { self.view?.render(state: .error(error.localizedDescription)) }
            }
        }
    }
    
    //MARK: - APPLE LOGIN
    func didTapAppleLogin() {
        router.startAppleFlow { [weak self] idToken, rawNonce, fullName in
            guard let self else { return }
            self.view?.render(state: .loading(true))
            
            Task {
                do {
                    let session = try await self.interactor.signInWithApple(idToken: idToken,nonce:rawNonce,fullName: fullName)
                    // (opsiyonel) kullanıcıyı persist etmek istiyorsan burada iste
                    await MainActor.run {
                        self.view?.render(state: .loading(false))
                        self.router.routeToHome(session: session)
                    }
                } catch {
                    await MainActor.run {
                        self.view?.render(state: .error(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    func didTapGoogleLogin() {
        
    }
    
    func didTapRegister(email: String?, password: String?) {
        guard let (e, p) = validate(email: email, password: password) else { return }
        view?.render(state: .loading(true))
        Task { [weak self] in
            guard let self else { return }
            do {
                let session = try await interactor.register(email: e, password: p)
                await MainActor.run {
                    self.view?.render(state: .loading(false))
                    self.router.routeToHome(session: session)
                }
            } catch {
                await MainActor.run { self.view?.render(state: .error(error.localizedDescription)) }
            }
        }
    }
    
    func didTapForgotPassword(email: String?) {
        guard let email = email, email.isValidEmail else {
            view?.render(state: .error("Geçerli bir e‑posta girin."))
            return
        }
        view?.render(state: .loading(true))
        Task { [weak self] in
            guard let self else { return }
            do {
                try await interactor.resetPassword(email: email)
                await MainActor.run { self.view?.render(state: .loading(false)) }
            } catch {
                await MainActor.run { self.view?.render(state: .error(error.localizedDescription)) }
            }
        }
    }
    
    private func validate(email: String?, password: String?) -> (String, String)? {
        guard let email, email.isValidEmail else {
            view?.render(state: .error("Geçerli bir e‑posta girin."))
            return nil
        }
        guard let password, password.count >= 6 else {
            view?.render(state: .error("Şifre en az 6 karakter olmalı."))
            return nil
        }
        return (email, password)
    }
    
    
    
}

private extension String {
    var isValidEmail: Bool {
        // Basic RFC5322-lite regex
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: utf16.count)) != nil
    }
}
