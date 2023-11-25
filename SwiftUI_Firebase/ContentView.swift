//
//  ContentView.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 5/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var navigateToNewView = false
   
    
    @State private var isUserNotAuthenticated : Bool = true
    
    
    var body: some View {
        ZStack {
             HomeView( isUserNotAuthenticated: $isUserNotAuthenticated)
            
         }.onAppear{
             let authUser = try? AuthManager.shared.getUser()
             self.isUserNotAuthenticated = authUser == nil ? true: false
             try? AuthManager.shared.checkSignInProvider()
            
     }
         .padding()
         .fullScreenCover(isPresented: $isUserNotAuthenticated){
             NavigationStack{
                 IntroView(isUserNotAuthenticated: $isUserNotAuthenticated)
             }
         }
    }
}
