//
//  LoginContracts.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation
import UIKit


/// Tüm protokoller burada


protocol LoginViewProtocol:AnyObject{
    func render(state:LoginViewState)
}

protocol LoginRouterProtocol: AnyObject {
    static func build(authService: AuthService) -> UIViewController
    func routeToHome(session: UserSession)
    func startAppleFlow(onResult: @escaping (_ idToken: String,
                                             _ rawNonce: String,
                                             _ fullName: PersonNameComponents?) -> Void) // ✅
}



protocol LoginPresenterProtocol:AnyObject{
    func onViewDidLoad()
    func didTapLogin(email:String?,password:String?)
    func didTapRegister(email:String?, password:String?)
    func didTapForgotPassword(email:String?)
    func didTapGoogleLogin()
    func didTapAppleLogin()
}


/// async → this function will suspend execution and resume when the operation is done.
///  throws → this function may fail (e.g., wrong password, network error, FirebaseAuth error).
///  ui kitlenmez async sayesinde throw ile hata alırsak kısmı için
///  User session burda da verilmeli db den gelecek modeli oturturoyurz.
protocol  LoginInteractorProtocol:AnyObject {
    func signIn(email:String,password:String) async throws -> UserSession
    func register(email:String,password:String)async throws -> UserSession
    func resetPassword(email:String)async throws
    func signInWithApple(idToken: String,
                         nonce: String,
                         fullName: PersonNameComponents?) async throws -> UserSession // ✅ eklendi
}
