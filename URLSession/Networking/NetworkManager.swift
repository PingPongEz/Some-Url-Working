//
//  NetworkManager.swift
//  URLSession
//
//  Created by u on 13.04.2022.
//

import Foundation
import UIKit
import Alamofire

enum NetworkError: Error {
    case noUrl
    case noData
    case cantDecode
}

struct Network {
    
    static func downloadImage(completion: @escaping (Data) -> Void) {
        guard let url = URL(string: "https://h5p.org/sites/default/files/h5p/content/1209180/images/file-6113d5f8845dc.jpeg") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Fuck")
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    
    
    static func fetch<T: Decodable>(type: T.Type,
                                    from url: String,
                                    isSnakeCased: Bool = false,
                                    completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.noUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                if isSnakeCased {
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                }
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.cantDecode))
            }
        }.resume()
    }
    
    static func postRequest(with data: [String: Any], to url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.noUrl))
            return
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: data) else {
            completion(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error desc")
                return
            }
            print(response)
            
            do {
                let something = try JSONSerialization.jsonObject(with: data)
                completion(.success(something))
            } catch {
                completion(.failure(.cantDecode))
            }
        }.resume()
    }
    
    static func postRequestModel(with data: RandomDog, to url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.noUrl))
            return
        }
        
        guard let data = try? JSONEncoder().encode(data) else {
            completion(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error desc")
                return
            }
            print(response)
            
            do {
                let someDog = try JSONDecoder().decode(RandomDog.self, from: data)
                completion(.success(someDog))
            } catch {
                completion(.failure(.cantDecode))
            }
        }.resume()
    }
    
    static func getDataAlamofire(_ url: String, completion: @escaping(Result<Joke, NetworkError>) -> Void) {
        AF.request(url, method: .get)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    
                    var jokeModel: Joke
                    
                    guard let joke = value as? [String: Any] else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    guard let flags = joke["flags"] as? [String: Any] else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    let type = Joke(type: joke)
                    let typeFlags = Flags(type: flags)
                    
                    jokeModel = type
                    jokeModel.flags = typeFlags
                    
                    DispatchQueue.main.async {
                        completion(.success(jokeModel))
                    }
                    //Это было сложно... Но так элементарно
                case .failure:
                    completion(.failure(.cantDecode))
                }
            }
    }
    
    static func postDataAlamofire(_ url: String, data: RandomDog, completion: @escaping(Result<RandomDog, NetworkError>) -> Void) {
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseDecodable(of: RandomDog.self) { dataResponse in
                switch dataResponse.result {
                case .success(let randomDog):
                    let dog = RandomDog(message: randomDog.message ?? "", status: randomDog.status ?? "")
                    DispatchQueue.main.async {
                        completion(.success(dog))
                    }
                case .failure:
                    completion(.failure(.cantDecode))
                }
            }
        
    }
}
