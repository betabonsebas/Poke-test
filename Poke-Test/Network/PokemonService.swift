//
//  PokemonService.swift
//  Poke-Test
//
//  Created by Sebastian Bonilla on 22/10/23.
//

import Combine
import Foundation

class PokemonService: Service {
  let baseURL: String
  
  init(baseURL: String) {
    self.baseURL = baseURL
  }
  
  func getAll(with page: Int, limit: Int) -> AnyPublisher<PokemonResults, Error>? {
    var urlRequest: URLRequest!
    
    guard var urlComponents = URLComponents(string: baseURL)  else {
      return nil
    }
    
    urlComponents.queryItems = [URLQueryItem(name: "limit", value: "\(limit)"), URLQueryItem(name: "Offset", value: "\(page * limit)")]
    guard let url = urlComponents.url else {
      return nil
    }
    
    urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return self.fetch(urlRequest: urlRequest)
  }
  
  func getItem(_ id: String) -> AnyPublisher<Pokemon, Error>? {
    var urlRequest: URLRequest!
    
    guard var urlComponents = URLComponents(string: baseURL)  else {
      return nil
    }
    
    urlComponents.path = urlComponents.path + "/\(id)"
    
    guard let url = urlComponents.url else {
      return nil
    }
    
    urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return fetch(urlRequest: urlRequest)
  }
  
  private func fetch<T>(urlRequest: URLRequest) -> AnyPublisher<T, Error>? where T: Decodable {
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .map{ $0.data }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError({ $0 as Error })
      .eraseToAnyPublisher()
  }
}
