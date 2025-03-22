//
//  Utility.swift
//  SecureApp
//
//  Created by Vijay N on 22/03/25.
//

import Foundation


func compilerDebugPrint(_ value: Any) {
    #if DEBUG
    print("Debug Print: \(value)")
    #endif
}

class CheckPrint {
    
    func check() {
        compilerDebugPrint("Checked")
    }
}
