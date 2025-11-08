//
//  APIClient.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 27.10.2025.
//

import Foundation

///APIClient.swift
//•    Ne yapar? Tüm HTTP isteklerinin ortak yürütücüsü. URLSession sarmalayıcıdır.
//•    Sorumluluk: Request’i hazırlar → gönderir → Decodable modele çevirir → hatayı NetworkError’a map’ler.
//•    İyi pratik: async/await, RequestAdapter/ResponseValidator gibi küçük eklentiler.
