//
//  SecureBioCheckView.swift
//  SecureApp
//
//  Created by Vijay N on 19/03/25.
//

import SwiftUI
import LocalAuthentication

struct SecureBioCheckView: View {
    
    @State var isAuthorizedUser: String = "- - -"
    
    var body: some View {
        VStack {
            Text("Is Authorized User : \(isAuthorizedUser)")
            Button("Authorization Check") {
                BiometricCheckManager.validateAuthorizedUser { isSuccess in
                    isAuthorizedUser = isSuccess ? "Yes" : "No"
                }
            }
        }
    }
}

#Preview {
    SecureBioCheckView()
}


class BiometricCheckManager {
    
    class func validateAuthorizedUser(completionHandler: @escaping ((Bool)->Void)) {
        
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate") { isSuccess, error in
            guard error == nil else
            {
                compilerDebugPrint("Biometric validation error: \(String(describing: error?.localizedDescription))")
                completionHandler(false)
                return
            }
            if isSuccess {
                compilerDebugPrint("Authentication Successful")
            } else {
                compilerDebugPrint("Authentication Failed")
            }
            completionHandler(isSuccess)
        }
    }
}



