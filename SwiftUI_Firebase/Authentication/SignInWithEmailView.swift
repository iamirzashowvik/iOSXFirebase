//
//  SignInWithEmailView.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import SwiftUI

final class SignInWithEmailViewModel : ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordHidden = true
    
    func togglePassword(){
        isPasswordHidden.toggle()
}
    
    func signIn() async throws{
        
        guard !email.isEmpty, !password.isEmpty else {
            print("email/password is empty")
            return
        }
        let _ = try await AuthManager.shared.signInUser(email: email, password: password);
    }
    func signUp() async throws{
        
        guard !email.isEmpty, !password.isEmpty else {
            print("email/password is empty")
            return
        }
        let _ = try await AuthManager.shared.createUser(email: email, password: password);
    }
}


struct SignInWithEmailView: View {
    @Binding var  isUserNotAuthenticated:Bool
    @ObservedObject private var viewModel = SignInWithEmailViewModel()
    var body: some View {
      VStack {
          TextField("Email..", text: $viewModel.email)
              .padding()
              .background(Color.gray.opacity(0.1))
              .cornerRadius(20)
          
         
              HStack {
                  if viewModel.isPasswordHidden {
                      SecureField("Password..", text: $viewModel.password)
                          .padding()
                          .background(Color.gray.opacity(0.1))
                      .cornerRadius(20)}
                  else {
                      TextField("Password..", text: $viewModel.password)
                          .padding()
                          .background(Color.gray.opacity(0.1))
                          .cornerRadius(20)
                  }
                  Image(systemName: viewModel.isPasswordHidden ? "eye.slash" : "eye" )
                                 .foregroundColor(.white)
                                 .padding()
                                 .background(Color.blue)
                                 .cornerRadius(20).onTapGesture {
                                     viewModel.togglePassword()
                                 }
                  
              }
          Button{
              Task{
                  do {
                     try await viewModel.signIn()
                      isUserNotAuthenticated = false
                      return
                  } catch {
                      print("Error \(error)")
                  }
                  do {
                     try await viewModel.signUp()
                      isUserNotAuthenticated = false
                      return
                  } catch {
                      print("Error \(error)")
                  }
              }
          } label: {
              Text("Sign In")
                  .foregroundColor(.white)
                  .frame(height: 55)
                  .frame(maxWidth: .infinity)
                  .background(Color.blue)
                  .cornerRadius(20)
          }
              
          
         
        }.navigationTitle("Sign In With Email")
            .padding()
        
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignInWithEmailView(isUserNotAuthenticated: .constant(true))
        }
    }
}
