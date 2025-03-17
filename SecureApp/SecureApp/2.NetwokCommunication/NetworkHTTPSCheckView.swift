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
            Button("Download Image") {
                //                Task {
                //                    NetworkHTTPSCheckViewModel.init().fetchImage()
                //                    NetworkHTTPSCheckViewModel.init().fetchUser()
                
                //                    NetworkHTTPSCheckViewModel.shared.fetchUser()
                //                    NetworkHTTPSCheckViewModel.shared.fetchImage()
                
                viewModel.fetchUser()
                //                    viewModel.fetchImage()
                
                //                }
                
            }
        }
    }
}

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
                    print("Api --> finished")
                case .failure(let err):
                    print("Api -->\(err)")
                }
            }, receiveValue: { data in
                
                print("Start")
                print(data)
                print("Middle")
                debugPrint(data)
                print("End")
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
                    print("Api fetch finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { userModel in
                print(userModel)
            }
            .store(in: &cancellables)
    }
    
}


public func safePrint(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
#if DEBUG
    let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t-> "
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(pretty+output, terminator: terminator)
#else
    Swift.print("RELEASE MODE")
#endif
}


struct UserModel: Codable, Identifiable {
    //    let id: Int
    //    init(from decoder: any Decoder) throws {
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //        self.name = try container.decode(String.self, forKey: .name)
    //        self.username = try container.decode(String.self, forKey: .username)
    //        self.email = try container.decode(String.self, forKey: .email)
    //        self.address = try container.decode(Address.self, forKey: .address)
    //        self.phone = try container.decode(String.self, forKey: .phone)
    //        self.website = try container.decode(String.self, forKey: .website)
    //        self.company = try container.decode(Company.self, forKey: .company)
    //    }
    //    let id = UUID()
    
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
