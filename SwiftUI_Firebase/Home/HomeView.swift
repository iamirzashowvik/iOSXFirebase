//
//  HomeView.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var  isUserNotAuthenticated:Bool
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button{
                AuthManager.shared.signOut()
                isUserNotAuthenticated = true
            } label: {
                Text("Log out")
                
            }
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
