import Foundation
import CryptoKit

protocol APIProtocol {
    func requestDataFrom(endpoint: Endpoint, completion: @escaping (Result<ResponseModel, APIError>) -> ())
}

class APIClient: APIProtocol {
    
    private let ts = "1"
    private let privateKey = "eee7256d362e37da3aa7441b45aa41b4735eb5ed"
    private let publicKey = "083cfa6df100c579f8e532fcdb63ac04"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    private let url = "https://gateway.marvel.com:443/v1/public/"

    private var token: String {
        let d = ts + privateKey + publicKey
        let md5 = Insecure.MD5.hash(data: d.data(using: .utf8)!)
                                                                .description
                                                                .split(separator: " ")
        let hash = md5[md5.count - 1]
        return String(hash)
    }
    
    static let shared = APIClient()
    private init() { }
    
    func requestDataFrom(endpoint: Endpoint, completion: @escaping (Result<ResponseModel, APIError>) -> ()) {
        guard let url = URL(string: "\(url)\(endpoint)?ts=\(ts)&apikey=\(publicKey)&hash=\(token)&") else {
            return
        }
        
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    private func loadURLAndDecode<T: Decodable>(url: URL, completion: @escaping (Result<T, APIError>) -> ()) where T : Decodable {
        let task = urlSession.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidEndpoint), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            if let responseData = try? self.jsonDecoder.decode(T.self, from: data){
                self.executeCompletionHandlerInMainThread(with: .success(responseData), completion: completion)
            } else {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
            
            
        }
        task.resume()
    }
    
    private func executeCompletionHandlerInMainThread<T:Decodable>(with result: Result<T,APIError>, completion: @escaping (Result<T, APIError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
