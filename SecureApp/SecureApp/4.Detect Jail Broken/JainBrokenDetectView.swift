//
//  JainBrokenDetectView.swift
//  SecureApp
//
//  Created by Vijay N on 18/03/25.
//

import SwiftUI

struct JainBrokenDetectView: View {
    @State var isJailBroken: String = "- - -"
    var body: some View {
        VStack {
            Text("Is Jail broken - \(isJailBroken)")
            Button("Detect Jail Broken device") {
                isJailBroken = JailBrokenChecker().isJailbroken() ? "Yes" : "No"
            }
        }
    }
}

#Preview {
    JainBrokenDetectView()
}

class JailBrokenChecker {
    
    init() {}
    
    func isJailbroken() -> Bool {
        let paths = ["/Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib"]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
}
