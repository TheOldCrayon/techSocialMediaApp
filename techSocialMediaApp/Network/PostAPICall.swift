import Foundation

extension URLSession {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"

    }
    
    func request(url: URL, method: HTTPMethod, body: [String: Any]?, queryParams: [String: Any]?, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let queryParams = queryParams {
               var queryItems = [URLQueryItem]()
               for (key, value) in queryParams {
                   if let stringValue = value as? String {
                       queryItems.append(URLQueryItem(name: key, value: stringValue))
                   } else if let intValue = value as? Int {
                       queryItems.append(URLQueryItem(name: key, value: String(intValue)))
                   }
               }
               urlComponents?.queryItems = queryItems
           }
        
        guard let requestUrl = urlComponents?.url else {
            completionHandler(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create request URL"])))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completionHandler(.failure(error))
                return
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = self.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let unknownError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                completionHandler(.failure(unknownError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP request failed with status code \(httpResponse.statusCode)"])
                completionHandler(.failure(statusCodeError))
                return
            }
            
            guard let responseData = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completionHandler(.failure(noDataError))
                return
            }
            
            completionHandler(.success(responseData))
        }
        print(url)
        task.resume()
    }
}
