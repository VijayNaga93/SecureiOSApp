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
            Button("Detect Jail Broken device - path") {
                isJailBroken = JailBrokenChecker().isJailbrokenWithPath() ? "Yes" : "No"
            }
            
            Button("Detect Jail Broken device - url") {
                isJailBroken = JailBrokenChecker().isJailbrokenWithUrl() ? "Yes" : "No"
            }
        }
    }
}

#Preview {
    JainBrokenDetectView()
}

class JailBrokenChecker {
    
    init() {}
    
    func isJailbrokenWithPath() -> Bool {
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
             "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
             "/private/var/lib/apt",
             "/private/var/lib/apt/",
             "/private/var/lib/cydia",
             "/private/var/mobile/Library/SBSettings/Themes",
             "/private/var/stash",
             "/private/var/tmp/cydia.log",
             "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
             "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
             "/usr/bin/sshd",
             "/usr/libexec/sftp-server", // This is exception for Simulator
             "/usr/sbin/sshd",
             "/etc/apt",
             "/bin/bash"
        ]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    func isJailbrokenWithUrl() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) ? true : false
    }
}
