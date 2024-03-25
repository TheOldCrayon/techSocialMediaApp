import Foundation

//extension URLSession {
//    enum Errors: Error {
//        case invalidURL
//        case invalidData
//    }
//    
//    func request<T: Codable>(
//    url: URL?,
//    expecting: T.Type,
//    queryParams: [String: String] = [:],
//    completion: @escaping(Result<T, Error>) -> Void) {
//        var components = URLComponents(url: url!, resolvingAgainstBaseURL: false)!
//        components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
//        guard let url = components.url else {
//            completion(.failure(Errors.invalidURL))
//            return
//        }
//        let task = self.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.failure(Errors.invalidData))
//                }
//                return
//            }
//            
//            do {
//                let result = try JSONDecoder().decode(expecting, from: data)
//                completion(.success(result))
//            }
//            catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}
