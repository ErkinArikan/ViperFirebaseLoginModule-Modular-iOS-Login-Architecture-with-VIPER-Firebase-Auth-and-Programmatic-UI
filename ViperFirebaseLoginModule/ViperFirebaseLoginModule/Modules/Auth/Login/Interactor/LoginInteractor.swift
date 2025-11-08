//
//  LoginInteractor.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation


class LoginInteractor:LoginInteractorProtocol{
    //    •    weak sadece karşılıklı tutma (retain cycle) durumlarında kullanılır.
    //    •    Interactor → AuthService tek yönlü olduğu için weak gerekmez.
    //    •    let kullanmak daha güvenli, çünkü auth değişmeyecek ve bellekte tutulacak. ✅
 
    
    private let auth:AuthService 
    
    
   
  
    init(authService: AuthService) {
        self.auth = authService
    }
    
    func signInWithApple(idToken: String,
                         nonce: String,
                         fullName: PersonNameComponents?) async throws -> UserSession {
        try await auth.signInWithApple(idToken: idToken, nonce: nonce, fullName: fullName)
    }
    
    func signIn(email: String, password: String) async throws -> UserSession {
        try await auth.signIn(email: email, password: password)
    }
    
    func register(email: String, password: String) async throws -> UserSession {
        try await auth.signUp(email: email, password: password)
    }
    
    
    
    func resetPassword(email: String, passwordResetLink: String) async throws {
        try await auth.sendPasswordReset(email: email)
    }
    
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(email: email)
    }
    
    
    
}
