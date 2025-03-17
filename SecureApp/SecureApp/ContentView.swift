//
//  ContentView.swift
//  SecureApp
//
//  Created by Vijay N on 16/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    NavigationLink("1. Keychain") {
                        DataStorageView(viewModel: DataStorageViewModel())
                    }
                    NavigationLink("2. Network Check HTTPS") {
                        NetworkHTTPSCheckView()
                    }
                }
            }
            .padding()
            .navigationTitle("Ways to secure iOS app")
        }
        
    }
}

#Preview {
    ContentView()
}
