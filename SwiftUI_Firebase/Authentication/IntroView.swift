

//
//  AuthenticationView.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import SwiftUI

struct IntroView: View {
    
    @Binding var  isUserNotAuthenticated:Bool
    
    
    
    
   func toggleIsUserNotAuthenticated(){
        isUserNotAuthenticated = false
    }
    
    
    @State private var urlX=""
    var body: some View {
        ZStack(alignment: .leading) {
            Image("highway").resizable()
            
            VStack(alignment: .leading) {
                
                
                 
                Spacer()
                Button(action: {
                    Task{
                        try  await AuthManager.shared.signInWithGoogle{
                            toggleIsUserNotAuthenticated()
                        }
                        
                    }
                }) {
                    HStack {
                       
                        Image("google_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(3)
                            .frame(width: 40, height: 40)
                            .cornerRadius(50)
                        Text("Google")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }.onAppear{
                    CacheManager.shared.getFileWith(stringUrl: "https://videosforxample.s3.ap-southeast-1.amazonaws.com/pexels-cedric-fauntleroy-7251362+(720p).mp4") { result in

                            switch result {
                            case .success(let url):
                                print(url.absoluteString)
                                DispatchQueue.main.async {
                                    self.urlX =  url.absoluteString
                                    
                                }
                                 // do some magic with path to saved video
                            case .failure(let error):
                                print(error)
                                // handle errror
                               
                            }
                        }
                }
                
                if urlX == "" {
                    Text("Loading...")
                }else{
//                    VStack{
//                        Text( urlX )
//
//                    }
                    
                    NavigationLink(destination: SignInWithEmailView(isUserNotAuthenticated: $isUserNotAuthenticated
                                                                    , url: urlX
                                                                   )
                    ) {
                        Text("Sign In with Email")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
            }
            .padding()
            .frame(height:UIScreen.screenHeight)
            .cornerRadius(20)
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Sign In")
        .navigationBarTitleTextColor(Color.white)
        .navigationBarBackButtonHidden(true)
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            IntroView(isUserNotAuthenticated: .constant(true))
        }
    }
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}

