//
//  LoginRouter.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation
import UIKit
import AuthenticationServices
import CryptoKit

///Router (veya Wireframe): Ekranlar arası geçişleri (navigasyon) ve modülün kurulumunu (bağlantılarını) yöneten katmandır.

final class LoginRouter: LoginRouterProtocol {
   
    
    
    
    weak var viewController: UIViewController?

    
///    1️⃣ Modülün kurulumu (module assembly / dependency injection)
//
///    Router genelde bir static func build() veya createModule() metoduna sahiptir.
// /   Bu metod modülün tüm parçalarını (View, Presenter, Interactor, Router) birbirine bağlar.
//
// /   Yani:
///        •    Hangi View kullanılacak?
///        •    Hangi Presenter, Interactor, Router oluşturulacak?
///        •    Hangi Service’ler Inject edilecek?
//
//    Bütün bu “bağlantıları” Router yapar.
    //Burda artık hangi servisi kullanacağını enjekte ediyoruz. istersek değiştiririz devamlı moc değerlerle.

    static func build(authService: AuthService) -> UIViewController {
        let interactor = LoginInteractor(authService: authService)
        let vc = LoginViewController()
        let router = LoginRouter()
        let presenter = LoginPresenter(view: vc, interactor: interactor, router: router)
        vc.presenter = presenter
        router.viewController = vc
        return vc
    }
    
    
   

    func routeToHome(session: UserSession) {
        // Replace with your real Home module
        let home = HomeViewController(session: session)
        if let nav = viewController?.navigationController {
            nav.setViewControllers([home], animated: true)
        } else {
            viewController?.present(UINavigationController(rootViewController: home), animated: true)
        }
    }
    // MARK: Apple Flow
        func startAppleFlow(onResult: @escaping (String, String, PersonNameComponents?) -> Void) {
            guard let vc = viewController else { return }
            let coordinator = AppleSignInCoordinator(presenter: vc, onResult: onResult)
            coordinator.start()
            // Koordinatörü gerekirse bir property’de tut (yaşam süresi için)
            objc_setAssociatedObject(self, &AssociatedKeys.appleCoordinator, coordinator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    
    
}
private enum AssociatedKeys { static var appleCoordinator = "appleCoordinator" }

final class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private weak var presenter: UIViewController?
    private let onResult: (String, String, PersonNameComponents?) -> Void
    private var rawNonce: String = ""

    init(presenter: UIViewController,
         onResult: @escaping (String, String, PersonNameComponents?) -> Void) {
        self.presenter = presenter
        self.onResult = onResult
    }

    func start() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        rawNonce = randomNonce()
        request.nonce = sha256(rawNonce)
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    // Presentation anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        presenter?.view.window ?? ASPresentationAnchor()
    }

    // Delegate: success
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credential.identityToken,
            let idToken = String(data: tokenData, encoding: .utf8)
        else { return }
        onResult(idToken, rawNonce, credential.fullName)
    }

    // Delegate: error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In error:", error.localizedDescription)
    }

    // Helpers
    private func randomNonce(_ length: Int = 32) -> String {
        precondition(length > 0)
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        while remaining > 0 {
            var random: UInt8 = 0
            _ = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if random < charset.count { result.append(charset[Int(random)]); remaining -= 1 }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        return SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
    }
}
