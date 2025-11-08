//
//  FirebaseAuthService.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
// firebase metodları burada bulunacak


class FirebaseAuthService:AuthService{
    
    
    // Apple ile doğrudan oturum açma
    func signInWithApple(idToken: String,nonce: String,fullName: PersonNameComponents?) async throws -> UserSession {
        // v11+ yeni API
        let credential = OAuthProvider.appleCredential(
            withIDToken: idToken,
            rawNonce: nonce,
            fullName: fullName // opsiyonel—ilk girişte dolabilir
        )
        
        do {
            // Eğer kendi async sarmalayıcın yoksa:
            // let result = try await Auth.auth().signIn(with: credential)
            let result = try await Auth.auth().signIn(with: credential)
            let uid = result.user.uid
            let mail = result.user.email ?? result.user.providerData.first?.email ?? ""
            return UserSession(uid: uid, email: mail)
        } catch {
            throw map(error)
        }
    }
    
    
    
    // FirebaseAuthService
    func signInWithGoogle(idToken: String, accessToken: String) async throws -> UserSession {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let result = try await Auth.auth().signIn(with: credential)
        return UserSession(uid: result.user.uid, email: result.user.email ?? "")
    }

 
    
    func signIn(email: String, password: String) async throws -> UserSession {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = result.user.uid
           
            return UserSession(uid: uid, email: email)
        } catch {
            throw map(error)
        }
    }
    
    func signUp(email: String, password: String) async throws -> UserSession {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
          
            return UserSession(uid: uid, email: email)
        } catch  {
            throw map(error)
        }
    }
    
    func sendPasswordReset(email: String) async throws {
        do {
           try await Auth.auth().sendPasswordReset(withEmail: email)

        } catch  {
            throw map(error)
        }
    }
    
    
//    Firebase SDK kendi hata sistemini kullanıyor (örneğin NSError(domain: AuthErrorDomain, code: 17009, userInfo: …) gibi).
//    Ama senin uygulaman VIPER yapısında Firebase SDK’yı bilmemeli — onun yerine kendi basit hata tipini (AuthError) kullanmalı.
//
//    Bu yüzden burada yapılan şey:
//
//    “Firebase’in hata kodlarını, uygulamanın anlayacağı AuthError enum’una dönüştürmek.”
    // Hata eşleme (mevcudu koru, bazı eklemeler yap)
    private func map(_ error: Error) -> AuthError {
        let ns = error as NSError
        guard ns.domain == AuthErrorDomain else { return .unknown }
        switch AuthErrorCode(rawValue: ns.code) {
        case .wrongPassword, .invalidCredential, .invalidEmail: return .invalidCredentials
        case .weakPassword: return .weakPassword
        case .emailAlreadyInUse, .credentialAlreadyInUse: return .emailAlreadyInUse
        case .userNotFound: return .userNotFound
        case .networkError: return .network
        default: return .unknown
        }
    }
    
    
}

extension Auth {
    func signInAsync(with credential: AuthCredential) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { cont in
            signIn(with: credential) { result, error in
                if let error { cont.resume(throwing: error) }
                else { cont.resume(returning: result!) }
            }
        }
    }
}

extension User {
    func linkAsync(with credential: AuthCredential) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { cont in
            link(with: credential) { result, error in
                if let error { cont.resume(throwing: error) }
                else { cont.resume(returning: result!) }
            }
        }
    }

    func reauthenticateAsync(with credential: AuthCredential) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { cont in
            reauthenticate(with: credential) { result, error in
                if let error { cont.resume(throwing: error) }
                else { cont.resume(returning: result!) }
            }
        }
    }
}
