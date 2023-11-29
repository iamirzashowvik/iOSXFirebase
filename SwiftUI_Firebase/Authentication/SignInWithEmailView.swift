//
//  SignInWithEmailView.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import SwiftUI

import AVKit


struct SignInWithEmailView: View {
    @Binding var  isUserNotAuthenticated:Bool
    let url:String
    @ObservedObject private var viewModel = SignInWithEmailViewModel()
    @State private var player = AVPlayer(url:URL(string: "https://videosforxample.s3.ap-southeast-1.amazonaws.com/pexels-cedric-fauntleroy-7251362+(720p).mp4")!)
    var body: some View {
        ZStack (){
            VideoPlayer(player: player)
                .onAppear() {

                    player.play()
                }.scaledToFill().ignoresSafeArea()
            XYZ.onAppear{
             
                player.replaceCurrentItem(with: AVPlayerItem(url:URL(string: url)!))
            }
        }.frame(width: UIScreen.screenWidth,height: UIScreen.screenHeight)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Sign In")
            .navigationBarTitleTextColor(Color.white)
//            .navigationBarBackButtonHidden(true)
        
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignInWithEmailView(isUserNotAuthenticated: .constant(true), url: "")
        }
    }
}



extension SignInWithEmailView{
    var XYZ:some View{
        VStack {
            
           
            Spacer()
            
          TextField("Email..", text: $viewModel.email)
                .frame(width:UIScreen.screenWidth-60)
                .padding()
              .background(.ultraThinMaterial)
              .cornerRadius(20)
              
              


              HStack {
                  if viewModel.isPasswordHidden {
                      SecureField("Password..", text: $viewModel.password)
                          .padding()
                          .background(.ultraThinMaterial)
                      .cornerRadius(20)}
                  else {
                      TextField("Password..", text: $viewModel.password)
                          .padding()
                          .background(.ultraThinMaterial)
                          .cornerRadius(20)
                  }
                  
                  Image(systemName: viewModel.isPasswordHidden ? "eye.slash" : "eye" )
                                 .foregroundColor(.white)
                                 .padding()
                                 .background(.thinMaterial)
                                 .cornerRadius(20).onTapGesture {
                                     viewModel.togglePassword()
                                 }

              }.frame(width:UIScreen.screenWidth-30)
                
             
            
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
          }.frame(width:UIScreen.screenWidth-30)
                .padding()



        }.padding()
        
    }
}


                        public enum Result<T> {
                            case success(T)
                            case failure(NSError)
                        }

                        class CacheManager {

                            static let shared = CacheManager()

                            private let fileManager = FileManager.default

                            private lazy var mainDirectoryUrl: URL = {

                                let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
                                return documentsUrl
                            }()

                            func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {


                                let file = directoryFor(stringUrl: stringUrl)

                                //return file path if already exists in cache directory
                                guard !fileManager.fileExists(atPath: file.path)  else {
                                    completionHandler(Result.success(file))
                                    return
                                }

                                DispatchQueue.global().async {

                                    if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                                        videoData.write(to: file, atomically: true)

                                        DispatchQueue.main.async {
                                            completionHandler(Result.success(file))
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            completionHandler(Result.failure(NSError(domain: "SomeErrorDomain", code:  -2001 )))
                                        }
                                    }
                                }
                            }

                            private func directoryFor(stringUrl: String) -> URL {

                                let fileURL = URL(string: stringUrl)!.lastPathComponent

                                let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)

                                return file
                            }
                        }
