//
//  UserDefaultsManager.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation


//Uygulama içi kalıcılık. Gizlilik ve erişim basitliği için soyutlanır.
//
//UserDefaultsManager.swift
//    •    Ne yapar? Küçük ayarlar/flag’ler (örn. “isOnboarded”, “lastEmail”).
//    •    İyi pratik: Anahtarları enum Key {} veya struct Keys {} ile topla; tip güvenli getter/setter yaz.


final class UserDefaultsManager {
  static let shared = UserDefaultsManager()
  private let ud = UserDefaults.standard
  var lastEmail: String? {
    get { ud.string(forKey: "last_email") }
    set { ud.setValue(newValue, forKey: "last_email") }
  }
}
