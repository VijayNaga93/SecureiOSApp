//
//  SSLPinningManager.swift
//  SecureApp
//
//  Created by Vijay N on 18/03/25.
//

import Foundation
import Security
import CommonCrypto
import Combine



class SSlPinningManager: NSObject,URLSessionDelegate {
    
    static let shared = SSlPinningManager()
    
    var isCertificatePinning:Bool = false
    
    var hardcodedPublicKey:String = "EumkTYs+nSg5q/mGi38Fjyg/I7lBU59PhayJy7/fx5k=."
    
    
    let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
    
    //MARK:- URLSessionDelegate
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge,nil)
            return
        }
        
        
        //extarct certificate from each api
        
        if self.isCertificatePinning {
            //compare certificates remote and local
            let certificate =  SecTrustGetCertificateAtIndex(serverTrust, 2)
            
            let policy = NSMutableArray()
            policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
            
            let isSecuredServer = SecTrustEvaluateWithError(serverTrust, nil)
            
            let remoteCertiData:NSData  = SecCertificateCopyData(certificate!)
            
            
            guard let pathToCertificate = Bundle.main.path(forResource: "GTS_Root_R1", ofType: "cer") else{
                fatalError("no local path found")
            }
            
            let localCertiData = NSData(contentsOfFile: pathToCertificate)
            if isSecuredServer && remoteCertiData.isEqual(to:localCertiData! as Data)  {
                compilerDebugPrint("Certificate   Pinning Completed Successfully")
                
                completionHandler(.useCredential, URLCredential.init(trust: serverTrust))
            }else{
                completionHandler(.cancelAuthenticationChallenge,nil)
            }
        }else{
            //compare Keys
            if let certificate =  SecTrustGetCertificateAtIndex(serverTrust, 2) {
                
                let serverPublicKey = SecCertificateCopyKey(certificate)
                let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey!, nil)
                let data:Data = serverPublicKeyData as! Data
                let serverHashKey = sha256(data: data)
                if serverHashKey == self.hardcodedPublicKey {
                    compilerDebugPrint("public key Pinning Completed Successfully")
                    completionHandler(.useCredential, URLCredential.init(trust: serverTrust))
                }else{
                    completionHandler(.cancelAuthenticationChallenge,nil)
                    
                }
            }
        }
    }
    
    func callAnyApi(urlString:String, isCertificatePinning:Bool, response:@escaping ((String)-> ())){
        
        let sessionObj = URLSession(configuration: .ephemeral, delegate: self,delegateQueue: nil)
        self.isCertificatePinning = isCertificatePinning
        var result:String =  ""
        
        guard let url = URL.init(string: urlString) else {
            fatalError("please add valid url first")
        }
        
        let task = sessionObj.dataTask(with: url) { (data, res, error) in
            
            if  error?.localizedDescription == "cancelled" {
                response("ssl Pinning failed")
            }
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                if self.isCertificatePinning {
                    response("ssl Pinning successful with Certificate Pinning")
                }else{
                    response("ssl Pinning successful with Public Key  Pinning")
                    
                }
            }
            
        }
        task.resume()
    }
    
    
    //    MARK: - Combine flow :
    
    var cancellables = Set<AnyCancellable>()
    
    func checkSSLPinningInCombineFlow(urlString:String, isCertificatePinning:Bool) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil).dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .eraseToAnyPublisher()
            .sink { completion in
                switch completion {
                case .finished:
                    compilerDebugPrint("Api fetch finished")
                case .failure(let err):
                    if err.localizedDescription == "cancelled" {
                        compilerDebugPrint("ssl Pinning failed")
                    } else {
                        print(err.localizedDescription)
                    }
                }
            } receiveValue: { value in
                compilerDebugPrint("Value-->\(value)")
            }
            .store(in: &cancellables)
    }
    
    
}

