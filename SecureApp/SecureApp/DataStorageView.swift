//
//  DataStorageView.swift
//  SecureApp
//
//  Created by Vijay N on 16/03/25.
//

import SwiftUI

struct DataStorageView: View {
    
    @State private var dataValueStr: String = ""
    @State private var dataServiceStr: String = ""
    @State private var retreivedValue: String = ""
    
    var viewModel: DataStorageViewModel
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            TextField("Enter data Service", text: $dataServiceStr)
            TextField("Enter data to Save", text: $dataValueStr)
            Text(retreivedValue)
            
            HStack(spacing: 50) {
                Button("Save") {
                    viewModel.keychainSave(value: dataValueStr, service: dataServiceStr)
                }
                Button("Retrieve") {
                    viewModel.keychainRetrieve(service: dataServiceStr)
                }
            }
            
            HStack(spacing: 50) {
                Button("Update") {
                    viewModel.keychainUpdate(value: dataValueStr, service: dataServiceStr)
                }
                Button("Delete") {
                    viewModel.keychainDelete(service: dataServiceStr)
                }
            }
            
        }
        .padding(50)
        
    }
}

#Preview {
    DataStorageView(viewModel: DataStorageViewModel())
}

class DataStorageViewModel: ObservableObject {
    
    func saveInUserDefaults() {
        UserDefaults.standard.set("password123", forKey: "userPassword") // Not Secure
    }
    
    func keychainSave(value: String, service: String) {
        if let data = value.data(using: .utf8) {
            KeychainHelper.saveToKeychain(data: data, service: service)
        }
    }
    
    func keychainRetrieve(service: String) {
        KeychainHelper.retrieveFromKeychain(service: service)
    }
    
    func keychainUpdate(value: String, service: String) {
        if let data = value.data(using: .utf8) {
            KeychainHelper.updateKeychain(data: data, service: service)
        }
    }
    
    func keychainDelete(service: String) {
        KeychainHelper.deleteFromKeychain(service: service)
    }
    
    
    
}
