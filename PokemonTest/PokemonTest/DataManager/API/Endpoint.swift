//
//  Endpoint.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 05/03/22.
//

import Foundation

protocol Endpoint {
    var path: String { get }
}

struct API {
    static let apiKey = ""
    static let url = "https://pokeapi.co/api/v2/"
}

enum PokemonEndpoint: Endpoint {
    typealias Query = [String : String]
    case pokemon
    case url(String)
    
    public var path: String {
        switch self {
        case .pokemon:
            return API.url + "pokemon"
        case let .url(urlString):
            return urlString
        }
    }
    
    private func createQuery(query: Query?) -> String {
        if let query = query {
            var queryString = "?"
            for (key, value) in query {
                queryString += "\(key)=\(value)&"
            }
            return queryString
        }
        return ""
    }
}
