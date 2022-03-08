//
//  PokemonListViewModel.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 07/03/22.
//

import Foundation

class PokemonListViewModel {
    struct Pokemon: Hashable {
        let name: String
        let url: String
        let identifier = UUID()
    }
    
    private let service: ServiceInput = RestClient()
    private var pokemons = [ListResponse]()
    private var nextListURL: String?
    var pokemonDetail: PokemonDetail?
    
    //MARK: - Bindable
    var showLoadingHud: Bindable = Bindable(false)
    var onShowAlert: Bindable<SingleButtonAlert?> = Bindable(nil)
    var onShowPokemon: Bindable<[Pokemon]> = Bindable([])
    
    init() {
        self.service.serviceHandler = self
        getPokemons()
    }
    
    private func getPokemons() {
        showLoadingHud.value = true
        service.get(obj: PokemonResponse.self, url: PokemonEndpoint.pokemon)
    }
    
    func morePokemon() {
        guard let nextListURL = nextListURL else {
            return
        }

        showLoadingHud.value = true
        service.get(obj: PokemonResponse.self, url: PokemonEndpoint.url(nextListURL))
    }
    
    func dataSourcePokemons() -> [Pokemon] {
        return pokemons.map { Pokemon(name: $0.name, url: $0.url) }
    }
    
    func getCountPokemon() -> Int {
        return pokemons.count
    }
    
}

extension PokemonListViewModel: ServiceOutput {
    func onResult<T>(_ result: T) {
        showLoadingHud.value = false
        if let result = result as? PokemonResponse {
            pokemons.append(contentsOf: result.results)
            onShowPokemon.value = result.results.map { Pokemon(name: $0.name, url: $0.url) }
            nextListURL = result.next
        }
    }
    
    func onError(_ error: DataManagerError) {
        showLoadingHud.value = false
        let alert = SingleButtonAlert(title: "Error",
                                      message: error.msg,
                                      action: AlertAction(buttonTitle: "OK",
                                                          handler: nil))
        onShowAlert.value = alert
    }
    
    func onResultData(_ data: Data) {}
}
