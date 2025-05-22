//
//  WebService.swift
//  Bankey
//
//  Created by Arunkumar on 22/05/25.
//

import UIKit

protocol WebServiceProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var fullURL: URL { get }
}

extension WebServiceProtocol {
    var fullURL: URL {
        URL(string: "\(baseURL)\(path)")!
    }
}

enum APIEndPoint: WebServiceProtocol {
    case profile
    case accounts
    
    var baseURL: URL {
        URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey")!
    }
    
    var path: String {
        switch self {
        case .profile: // We are hardcoding the 1 for userID otherwise only path will be declared here
            return "/profile/1"
        case .accounts:
            return "/profile/1/accounts"
        }
    }
}

enum NetworkError: Error {
    case serverError
    case parsingError
}

struct WebService {
    
    static let shared = WebService()
    
    func fetch<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedModel = try decoder.decode(T.self, from: data)
                    completion(.success(decodedModel))
                } catch {
                    completion(.failure(.parsingError))
                }
            }
        }.resume()
    }
    
}
