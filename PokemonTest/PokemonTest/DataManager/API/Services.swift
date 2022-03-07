//
//  Services.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 05/03/22.
//

import Foundation

protocol ServiceInput: AnyObject {
    var serviceHandler: ServiceOutput? { get set }
    func get<T: Any>(obj: T.Type, url: Endpoint) where T: Decodable
    func getData(from url: String)
}

protocol ServiceOutput: AnyObject {
    func onResult<T: Any>(_ result: T)
    func onError(_ error: DataManagerError)
    func onResultData(_ data: Data)
}
