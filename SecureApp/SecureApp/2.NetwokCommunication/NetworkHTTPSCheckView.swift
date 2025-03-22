//
//  NetworkHTTPSCheckView.swift
//  SecureApp
//
//  Created by Vijay N on 17/03/25.
//

import SwiftUI
import Combine

struct NetworkHTTPSCheckView: View {
    
    var viewModel = NetworkHTTPSCheckViewModel()
    
    var body: some View {
        VStack {
            Button("Check api call") {
                viewModel.fetchUser()
                viewModel.fetchImage()
            }
        }
    }
}

/*
 Note:
 Try http and https url's
 https will success
 http will fail
 */

#Preview {
    NetworkHTTPSCheckView()
}

class NetworkHTTPSCheckViewModel: ObservableObject {
    
    //    static var shared = NetworkHTTPSCheckViewModel()
    
    var cancellables = Set<AnyCancellable>()
    
    
    func fetchImage() {
        //        let urlStr = "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U"
        let urlStr = "http://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U"
        
        
        guard let url = URL(string: urlStr) else { return }
        
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { subscriber in
                switch subscriber {
                case .finished:
                    compilerDebugPrint("Api --> finished")
                case .failure(let err):
                    compilerDebugPrint("Api -->\(err)")
                }
            }, receiveValue: { data in
                
                compilerDebugPrint("Start")
                print(data)
                compilerDebugPrint("Middle")
                debugPrint(data)
                compilerDebugPrint("End")
            })
            .store(in: &cancellables)
        
        
        
    }
    
    func fetchUser() {
        
        //        let urlStr = "https://jsonplaceholder.typicode.com/users"
        let urlStr = "http://jsonplaceholder.typicode.com/users"
        
        guard let url = URL(string: urlStr) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink { completion in
                switch completion {
                case .finished:
                    compilerDebugPrint("Api fetch finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { userModel in
                print(userModel)
            }
            .store(in: &cancellables)
    }
}


struct UserModel: Codable, Identifiable {
    var id: Int
    let name: String
    let username: String
    let email: String?
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}
