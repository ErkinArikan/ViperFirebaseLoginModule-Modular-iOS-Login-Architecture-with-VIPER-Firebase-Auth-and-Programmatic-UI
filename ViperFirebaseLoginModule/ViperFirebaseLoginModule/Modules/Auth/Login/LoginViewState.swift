//
//  LoginViewState.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation

//UI state’leri (opsiyonel)
enum LoginViewState: Equatable {
    case idle
    case loading(Bool)
    case error(String)
}
