//
//  PokemonResponse.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 05/03/22.
//

import Foundation

struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let results: [ListResponse]
}

struct ListResponse: Codable {
    let name: String
    let url: String
}
