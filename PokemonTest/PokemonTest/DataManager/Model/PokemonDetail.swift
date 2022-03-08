//
//  PokemonDetail.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 05/03/22.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let moves: [PokemonMove]
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let sprites: Sprites
}

struct PokemonInfo: Codable {
    let name: String
}

struct PokemonType: Codable {
    let type: PokemonInfo
}

struct PokemonMove: Codable {
    let move: PokemonInfo
}

struct PokemonAbility: Codable {
    let ability: PokemonInfo
}

struct Sprites: Codable {
    let other: OtherSprites
}

struct OtherSprites: Codable {
    let official: OfficialArt
    
    enum CodingKeys: String, CodingKey {
        case official = "official-artwork"
    }
}

struct OfficialArt: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
