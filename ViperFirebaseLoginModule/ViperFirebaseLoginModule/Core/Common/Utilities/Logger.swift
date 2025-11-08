//
//  Logger.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation

//Logger.swift
//    •    Ne yapar? Centralized logging. Prod’da azalt, debug’da detaylı.
//    •    İyi pratik: OSLog veya 3rd party yerine küçük bir wrapper yeterli.

enum Log {
  static func info(_ msg: String)   { print("ℹ️ \(msg)") }
  static func error(_ msg: String)  { print("❌ \(msg)") }
}
