//
//  SecureAppApp.swift
//  SecureApp
//
//  Created by Vijay N on 16/03/25.
//

import SwiftUI

@main
struct SecureAppApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            DataStorageView(viewModel: DataStorageViewModel())
        }
    }
}
