//
//  NetworkManager.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 18.12.2021.
//

import Foundation

/// NetworkManager class
class NetworkManager{
    /// Singleton instance
    static let shared = NetworkManager()
    /// instance of NSCache for caching images
    private var images = NSCache<NSString, NSData>()
    /// API_KEY for request
    private let apiKey = "819ae09576efb5624e56b7234336aefa7c6cb80fb06273566a9d97dbcf828db8"
    
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
      }
    
    /// URLComponents
    /// - Returns: instance URLComponents
    func components() -> URLComponents{
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "serpapi.com"
        return comp
    }
    
    /// Fetching by query
    /// - Parameters:
    ///   - query: query String
    ///   - completion: [ImagesResult]?, Error?
    func fetchImagesByQuery(query: String, completion: @escaping ([ImagesResult]?, Error?) -> (Void)){
        let path = "/search.json"
        
        var comp = components()
        comp.path = path
        
        comp.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "tbm", value: "isch"),
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = comp.url else{
            return
        }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)else{
                      completion(nil, NetworkManagerError.badResponse(response))
                      return
                  }
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }

            do{
                let response = try JSONDecoder().decode(QueryModel.self, from: data)
                completion(response.imagesResults, nil)
                return
            }catch let error{
                debugPrint("json decoder error: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
        
        
    }
    
    /// Public methods for calling from ViewController
    /// - Parameters:
    ///   - imageResult: imageResult
    ///   - completion: completion: Data?, Error?
    func image(imageResult: ImagesResult, completion: @escaping (Data?, Error?) -> (Void)){
        let url = URL(string: imageResult.thumbnail)!
        download(imageURL: url, completion: completion)
    }
    
    /// This methods store in NSCache image by URL, if image doesn't exists, in first with URLSession downloads image after caches in NSCache
    /// - Parameters:
    ///   - imageURL: imageURL URL
    ///   - completion: completion: Data?, Error?
    private func download(imageURL: URL, completion: @escaping(Data?, Error?) -> (Void)){
        if let imageData = images.object(forKey: imageURL.absoluteString as NSString){
            print("using cached images")
            completion(imageData as Data, nil)
            return
        }
        
        let task = session.downloadTask(with: imageURL){ localUrl, response, error in
            if let error = error {
                    completion(nil, error)
                    return
                  }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                completion(nil, NetworkManagerError.badResponse(response))
                        return
            }
            guard let localUrl = localUrl else {
                    completion(nil, NetworkManagerError.badLocalUrl)
                    return
                  }
            do{
                let data = try Data(contentsOf: localUrl)
                self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, nil)
            }catch let error{
                completion(nil, error)
            }
            
        }
        task.resume()
    }
}



/// Enum for NetworkManager errors
enum NetworkManagerError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}
