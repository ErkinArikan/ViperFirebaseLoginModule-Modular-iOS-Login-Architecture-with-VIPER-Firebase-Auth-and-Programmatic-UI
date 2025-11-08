//
//  DependencyContainer.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation

//DependencyContainer.swift (opsiyonel ama düzenli)
//
//Ne yapar? Uygulama çapında bağımlılıkların oluşturulması ve yaşam döngüsünün yönetimi (APIClient, Services).
//    •    Küçük projede Router Builder’lar yeter; büyüdükçe container iyi olur.
//
//final class DependencyContainer {
//  static let shared = DependencyContainer()
//
//  lazy var apiClient: APIClient = DefaultAPIClient()
//  lazy var authService: AuthService = FirebaseAuthService()
//
//  // Factory örneği:
//  func makeLoginModule() -> UIViewController {
//    LoginRouter.build(authService: authService)
//  }
//}
