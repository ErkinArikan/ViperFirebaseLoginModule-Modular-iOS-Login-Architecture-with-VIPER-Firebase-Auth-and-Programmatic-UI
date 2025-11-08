//
//  ViewController.swift
//  ViperFirebaseLoginModule
//
//  Created by Erkin Arikan on 24.10.2025.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Task {
            do {
              let created = try await Auth.auth().createUser(withEmail: "test@example.com", password: "123456")
              print("✅ Created:", created.user.uid)
            } catch { print("❌ Create failed:", error) }

            do {
              let signedIn = try await Auth.auth().signIn(withEmail: "test@example.com", password: "123456")
              print("✅ Sign-in OK:", signedIn.user.uid)
            } catch { print("❌ Sign-in failed:", error) }
        }
    }


}

