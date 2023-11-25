//
//  AuthManager.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn



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
                                               email, password: password)
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
    
    func verifyEmail() {
        Task{
            do{
                 Auth.auth().currentUser?.sendEmailVerification { error in
                 print(error)
                }
            }
        }
    }
    
   
    func resetPassword() {
        Task{
            do{
               try Auth.auth().sendPasswordReset(withEmail: getUser().email!) { error in
                    print(error)
                }
            }
        }
    }
    
    
    func checkSignInProvider() throws-> [AuthProviderOption]{
        
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        var providers :[AuthProviderOption]=[]
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID){
                providers.append(option)
            } else{
                assertionFailure("Provider option not found")
            }
        }
        return providers;
    }
    
    
    func signInWithGoogle(){
        Task {
        
            do{
                guard let presentingVC = await (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
                  
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                // Create Google Sign In configuration object.
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config

                // Start the sign in flow!
                GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [unowned self] result, error in
                  guard error == nil else {
                      return
                  }

                  guard let user = result?.user,
                    let idToken = user.idToken?.tokenString
                  else {
                    return
                  }

                  let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                 accessToken: user.accessToken.tokenString)
                    Auth.auth().signIn(with: credential) { result, error in

                      // At this point, our user is signed in
                    }
                        
                  // ...
                }
            }
        }
    }
}


enum AuthProviderOption:String{
    case email = "password"
    case gmail = "google.com"
}
