//
//  SSLPinningCheckView.swift
//  SecureApp
//
//  Created by Vijay N on 18/03/25.
//

import SwiftUI

struct SSLPinningCheckView: View {
    var body: some View {
        VStack {
            Button("Check SSL") {
                
//                SSlPinningManager.shared.callAnyApi(urlString: "https://www.google.com", isCertificatePinning: false) { (response) in
//                    print(response)
//                }
                
                SSlPinningManager.shared.checkSSLPinningInCombineFlow(urlString: "https://www.google.com", isCertificatePinning: false)
            }
        }
    }
}

#Preview {
    SSLPinningCheckView()
}
