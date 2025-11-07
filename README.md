# ViperFirebaseLoginModule-Modular-iOS-Login-Architecture-with-VIPER-Firebase-Auth-and-Programmatic-UI
A clean and scalable iOS login module built with VIPER architecture, Firebase Authentication, and fully programmatic UI using SnapKit and Then. Designed for reusability, testability, and modern async/await networking.

---

## 🧱 Features
✅ **VIPER Architecture**
- Clean separation of responsibilities: View, Interactor, Presenter, Entity, Router  
- Fully modular, easy to test and extend  

✅ **Firebase Authentication**
- Email & Password authentication  
- Password reset flow  
- Extensible for Apple / Google Sign-In  
- Async/Await support for modern Swift concurrency  

✅ **Programmatic UI**
- Built 100% in code (no Storyboard)  
- Auto Layout with [SnapKit](https://github.com/SnapKit/SnapKit)  
- Clean initialization using [Then](https://github.com/devxoul/Then)

✅ **Dependency Injection**
- AuthService protocol + FirebaseAuthService implementation  
- Easily swappable with mock services for testing

✅ **Coordinator-friendly Router**
- Handles navigation and Apple Sign-In presentation logic  
- Decoupled from Presenter, aligned with SOLID principles  

---


## 🏗️ Architecture Overview

- **View** → UI layer built with UIKit + SnapKit  
- **Presenter** → Business flow & user interaction handler  
- **Interactor** → Executes login logic using AuthService  
- **Router** → Manages navigation and external flows (Apple Sign-In)  
- **Entity** → Represents models like `UserSession`  

---

## 🔧 Technologies
| Tool / Framework | Purpose |
|------------------|----------|
| **Swift 5.9+** | Core language |
| **VIPER** | Modular architecture |
| **FirebaseAuth** | Authentication backend |
| **SnapKit** | Auto Layout DSL |
| **Then** | Cleaner UIKit initializers |
| **CryptoKit** | Nonce generation for Apple Sign-In |
| **AuthenticationServices** | Apple Sign-In UI |

---

## ⚙️ Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_GITHUB_USERNAME/ViperFirebaseLoginModule.git
