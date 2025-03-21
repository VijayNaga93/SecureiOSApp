//
//  SecureAppApp.swift
//  SecureApp
//
//  Created by Vijay N on 16/03/25.
//

import SwiftUI

@main
struct SecureAppApp: App {
    @State private var isAppInBackground = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay(
                    isAppInBackground ? Color.black.ignoresSafeArea() : nil // Cover screen when in background
                )
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    isAppInBackground = true
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    isAppInBackground = false
                }
        }
    }
}


/*
 iOS App Security:
 https://medium.com/adessoturkey/ios-app-security-96c32ba4e036
 */


