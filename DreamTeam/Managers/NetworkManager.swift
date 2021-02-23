//
//  NetworkManager.swift
//  DreamTeam
//
//  Created by Николаев Никита on 20.02.2021.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Request and error types
    private enum requestType {
        case hero
        case quote
    }
    
    enum NetworkError: Error {
        case networkError
        case invalidURL
        case emptyData
        case decodeError
    }
    
    // MARK: - Private methods
    private func getURL(for type: requestType) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.sheme
        components.host = Constants.host
        switch type {
        case .hero:
            components.path = Constants.randomHeroPath
        case .quote:
            components.path = Constants.randomQuotePath
        }
        return components.url
    }
    
    private func parseJSON<T: Decodable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let responseModel = try decoder.decode(type, from: data)
            return responseModel
        } catch {
            print(error)
        }
        return nil
    }
    
    // MARK: - Public methods
    func fetchHero(completion: @escaping (Result<[HeroResponse], NetworkError>) -> ()) {
        guard let url = getURL(for: .hero) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            guard let decodedData = self.parseJSON(data: data, type: [HeroResponse].self) else {
                completion(.failure(.decodeError))
                return
            }
            completion(.success(decodedData))
        }.resume()
    }
    
    func fetchQuote(completion: @escaping (Result<[QuoteResponse], NetworkError>) -> ()) {
        guard let url = getURL(for: .quote) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            guard let decodedData = self.parseJSON(data: data, type: [QuoteResponse].self) else {
                completion(.failure(.decodeError))
                return
            }
            completion(.success(decodedData))
        }.resume()
    }
    
    // MARK: - Constants
    private enum Constants {
        static let sheme = "https"
        static let host = "www.breakingbadapi.com"
        static let randomHeroPath = "/api/character/random"
        static let randomQuotePath = "/api/quote/random"
    }
}


