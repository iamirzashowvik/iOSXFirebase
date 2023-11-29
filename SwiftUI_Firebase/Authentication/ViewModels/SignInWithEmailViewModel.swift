//
//  SignInWithEmailViewModel.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 29/11/23.
//

import Foundation
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordHidden = true
    
    func togglePassword() {
        isPasswordHidden.toggle()
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("email/password is empty")
            return
        }
        let _ = try await AuthManager.shared.signInUser(email: email, password: password)
    }

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("email/password is empty")
            return
        }
        let _ = try await AuthManager.shared.createUser(email: email, password: password)
    }
}
