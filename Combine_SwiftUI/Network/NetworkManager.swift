//
//  NetworkManager.swift
//  Combine_SwiftUI
//
//  Created by Sunil Kumar on 01/06/23.
//

import Foundation
import Combine

enum Endpoint: String {
  case properties = "iranjith4/ad-assignment/db"
  case someEndPoint = "end/Point"
}

class NetworkManager {
  
  static let shared = NetworkManager()
  
  private init() {
  }
  
  private var cancellables = Set<AnyCancellable>()
  private let baseURL = "https://my-json-server.typicode.com/"
  
  
  func getData<T: Decodable>(endpoint: Endpoint,
                             type: T.Type) -> Future<T, Error> {
    
    return Future<T, Error> { [weak self] promise in
      
      guard let self = self, let url = URL(string: self.baseURL.appending(endpoint.rawValue)) else {
        return promise(.failure(NetworkError.invalidURL))
      }
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      
      print("URL is \(url.absoluteString)")
      URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { (data, response) -> Data in
          guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.responseError
          }
          return data
        }
        .decode(type: T.self, decoder: decoder)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
          if case let .failure(error) = completion {
            switch error {
            case let decodingError as DecodingError:
              promise(.failure(decodingError))
            case let apiError as NetworkError:
              promise(.failure(apiError))
            default:
              promise(.failure(NetworkError.unknown))
            }
          }
        }, receiveValue: { promise(.success($0)) })
        .store(in: &self.cancellables)
    }
  }
}


enum NetworkError: Error {
  case invalidURL
  case responseError
  case unknown
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return NSLocalizedString("Invalid URL", comment: "Invalid URL")
    case .responseError:
      return NSLocalizedString("Unexpected status code", comment: "Invalid response")
    case .unknown:
      return NSLocalizedString("Unknown error", comment: "Unknown error")
    }
  }
}
