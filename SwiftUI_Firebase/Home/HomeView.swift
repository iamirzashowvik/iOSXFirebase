//
//  HomeView.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import SwiftUI

final class HomeViewModel:ObservableObject{
    @Published var signInProvider :[AuthProviderOption]=[]
    
    func loadProviders(){
        if let provider = try? AuthManager.shared.checkSignInProvider(){
            signInProvider=provider
        }
        print(signInProvider)
    }
}

struct HomeView: View {
    @StateObject var vm=HomeViewModel()
    @Binding var  isUserNotAuthenticated:Bool
   
   
    var body: some View {
      VStack {
          List{
              Text("Settings")
                 .font(.headline)
             
             Button{
                 AuthManager.shared.signOut()
                 isUserNotAuthenticated = true
             } label: {
                 Text("Log out")
                 
             }
          }
           
          if vm.signInProvider.first == AuthProviderOption.email{
               VStack{
                   List(){
                       Button{
                           AuthManager.shared.resetPassword()
                       } label: {
                           Text("Reset Password")
                           
                       }
                       
                        Button{
                            AuthManager.shared.verifyEmail()
                        } label: {
                            Text("Verify Email")
                            
                        }
                       Button{
                           AuthManager.shared.resetPassword()
                       } label: {
                           Text("Reset Password")
                           
                       }
                   }
               }
           }
          Spacer()
            
       }.onAppear {
           vm.loadProviders()
        
       }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HomeView( isUserNotAuthenticated: .constant(false))
        }
    }
}
