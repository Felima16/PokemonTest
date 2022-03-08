//
//  PokemonCellViewModel.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 08/03/22.
//

import Foundation

class PokemonCellViewModel {
    private let service: ServiceInput = RestClient()
    var pokemonImageData: Data?
    var pokemon: PokemonDetail?
    
    //MARK: - Bindable
    var showLoadingHud: Bindable = Bindable(false)
    var onShowImage: Bindable<Data?> = Bindable(nil)
    
    init() {
        self.service.serviceHandler = self
    }
    
    func getPokemonDetail(url: String) {
        showLoadingHud.value = true
        service.get(obj: PokemonDetail.self, url: PokemonEndpoint.url(url))
    }
    
    private func getImage() {
        guard let url = pokemon?.sprites.other.official.frontDefault else {
            return
        }
        service.getData(from: url)
    }
}

extension PokemonCellViewModel: ServiceOutput {
    func onResult<T>(_ result: T) {
        showLoadingHud.value = false
        if let result = result as? PokemonDetail {
            pokemon = result
            getImage()
        }
    }
    
    func onError(_ error: DataManagerError) {}
    
    func onResultData(_ data: Data) {
        pokemonImageData = data
        onShowImage.value = data
    }
}
