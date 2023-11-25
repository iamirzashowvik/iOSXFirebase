//
//  AuthManager.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel{
    let uid:String
    let email:String?
    let photo:String?
    
    init(user:User) {
        self.uid = user.uid
        self.email = user.email
        self.photo = user.photoURL?.absoluteString
    }
    
}

final class AuthManager{
    
    static let shared = AuthManager()
  private  init(){
        
    }
   
    @discardableResult
    func createUser(email:String, password:String) async throws -> AuthDataResultModel{
        print("create user")
      let authResult = try await  Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authResult.user)
    }
    
    func signInUser(email:String, password:String) async throws -> AuthDataResultModel{
        print("sign in")
      let authResult = try await  Auth.auth().signIn(withEmail:
                                                        "showvikmirza@gmail.com", password: "123456")
        print(authResult.user.email)
        return AuthDataResultModel(user: authResult.user)
    }
    
    func getUser() throws -> AuthDataResultModel{
        guard let authResult = Auth.auth().currentUser else{
           throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: authResult)
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          print("signed out")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
