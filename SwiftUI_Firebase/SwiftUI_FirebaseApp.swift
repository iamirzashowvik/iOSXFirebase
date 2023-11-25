//
//  SwiftUI_FirebaseApp.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 5/11/23.
//

import SwiftUI
import FirebaseCore

@main
struct SwiftUI_FirebaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
