//
//  AuthService.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

///Servisler, işlevsel alan bazında soyutlamalardır (Auth, Payments, Analytics…). VIPER Interactor’ları bu protokollere bağımlıdır.

///Ne yapar? Giriş/kayıt/şifre yenileme gibi işlemler için arayüz.
///    Amaç: Interactor → (sadece) AuthService’i bilir; Firebase/REST fark etmez.
protocol AuthService {
    func signIn(email: String, password: String) async throws -> UserSession
    func signUp(email: String, password: String) async throws -> UserSession
    func sendPasswordReset(email: String) async throws
    func signInWithApple(idToken: String, nonce: String,fullName: PersonNameComponents?) async throws -> UserSession
    func signInWithGoogle(idToken: String, accessToken: String) async throws -> UserSession
    
}



/// Error tiplerimiz
enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case weakPassword
    case emailAlreadyInUse
    case userNotFound
    case network
    case unknown
    case couldntSignIn
    case couldntLogIn

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "E‑posta veya şifre hatalı."
        case .weakPassword: return "Şifre çok zayıf."
        case .emailAlreadyInUse: return "Bu e‑posta zaten kayıtlı."
        case .userNotFound: return "Kullanıcı bulunamadı."
        case .network: return "Ağ hatası. Lütfen tekrar deneyin."
        case .unknown: return "Bilinmeyen bir hata oluştu."
        case .couldntSignIn: return "Something went wrong while signing in."
        case .couldntLogIn: return "Something went wrong while logging in."
        }
    }
}


