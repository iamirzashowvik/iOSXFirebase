//
//  AuthenticationView.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import SwiftUI

struct IntroView: View {
    
    @Binding var  isUserNotAuthenticated:Bool
    var body: some View {
        VStack {
            Spacer()
            NavigationLink{
                SignInWithEmailView(isUserNotAuthenticated: $isUserNotAuthenticated)
            } label: {
                
                Text("Sign In with Email")
                     .font(.headline)
                     .foregroundColor(.white)
                     .frame(height:55)
                     .frame(maxWidth: .infinity)
                 
                     .background(Color.blue)
                     .cornerRadius(20)
                
            }
            
        }   .navigationTitle("Sign In")
            .navigationBarBackButtonHidden(true)
            .padding()
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            IntroView(isUserNotAuthenticated: .constant(true))
        }
    }
}
