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
                    
                    NavigationLink("3. SSL Pinning") {
                        SSLPinningCheckView()
                    }
                    
                    NavigationLink("4. Jail Broken Detect") {
                        JainBrokenDetectView()
                    }
                    
                    NavigationLink("5. Secure Authorization Bio-Metric") {
                        SecureBioCheckView()
                    }
                    
                    NavigationLink("6. Screen shot block") {
                        ScreenShotBlockView()
                    }
                    
                    NavigationLink("7. Screen Record block") {
                        ScreenRecordBlockView()
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
