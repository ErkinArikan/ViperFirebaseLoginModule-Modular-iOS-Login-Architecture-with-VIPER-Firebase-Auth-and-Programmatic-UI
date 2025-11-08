//
//  AppRouter.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 6.11.2025.
//

import Foundation

import UIKit

final class AppRouter {
    static func root() -> UIViewController {
        let login = LoginRouter.build(authService: FirebaseAuthService())
        return UINavigationController(rootViewController: login)
    }
}
