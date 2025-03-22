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

/*
 Note:
 To test biometric authentication on the iOS Simulator:

 1. Enable Face ID: Go to Simulator > Features > Face ID > Enrolled
 2. Test with a Matching Face: Go to Simulator > Features > Face ID > Matching Face
 3. Test with a Non-matching Face: Go to Simulator > Features > Face ID > Non-matching Face

 */


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



