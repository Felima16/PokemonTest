//
//  DataManagerError.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 05/03/22.
//

import Foundation

enum DataManagerError: Error{
    case notAvailable
    case invalidAPIKey
    case serviceCurrentlyUnavailable
    case badURLFound
    case noTransformObj
    case genericError
    case downloadError
        
    public var msg: String{
        switch self{
        case .notAvailable:
            return "The TheCAT API search databases are temporarily unavailable."
        case .invalidAPIKey:
            return "The API key passed was not valid or has expired."
        case .serviceCurrentlyUnavailable:
            return "The requested service is temporarily unavailable."
        case .badURLFound:
            return "One or more arguments contained a URL that has been used for abuse on TheCAT."
        case .noTransformObj:
            return "Object can't transform"
        case .genericError:
            return "an error occurred"
        case .downloadError:
            return "an error occurred with download"
        }
    }
}
