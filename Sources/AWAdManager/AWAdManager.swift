import Foundation
import AWNetworkManager

public protocol AWAdManagerDelegate: AnyObject {
    func didLoad(ads: [AWAd])
    func didFail(with error: Error)
}

public struct AWAd: Codable {
    let title, subtitle, url, image: String
}


public struct AWAdManager {
    
    public var delegate: AWAdManagerDelegate?
    public var ads: [AWAd] = []
    
    init(delegate: AWAdManagerDelegate) {
        self.delegate = delegate
        fetch()
    }
    
    public func reload() {
        fetch()
    }
    
    private func fetch() {
        
        var request = URLRequest(url: URL(string: String(format: "https://aww-coding.com/ads/list.php"))!)
        request.timeoutInterval = 30
        request.httpMethod = "GET"
        AWNetworkManager.begin(request) { (response) in
            
            switch response {
                case.success(let data):
                    guard let ads = try? JSONDecoder().decode([AWAd].self,
                                                              from: Crypto().encode(data: data, key: 75)) else {
                        print("Unable to parse ads")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        delegate?.didLoad(ads: ads)
                    }
                    
                    
                case .failure(let error):
                    
                    DispatchQueue.main.async {
                        delegate?.didFail(with: error)
                    }
            }
        }
    }
}


private struct Crypto {
    
    var key: Int = 0
    
    func encode(data: Data, key: Int) -> Data {
        var value = String()
        if let str = String(data: data, encoding: .utf8) {
            value = xor(text: str, key: UInt8(key))
        }
        return value.data(using: .utf8) ?? Data()
    }

    func xor(text: String, key: UInt8) -> String {
        return String(bytes: text.utf8.map{$0 ^ key}, encoding: String.Encoding.utf8) ?? ""
    }
    
}
