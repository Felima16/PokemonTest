//
//  PokemonDetailViewController.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 08/03/22.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokeInfoTableView: UITableView!
    var pokemonDetail: PokemonDetail?
    var pokemonImage: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = pokemonDetail?.name
        if let data = pokemonImage {
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.pokemonImageView.image = image
            }
        }
        pokeInfoTableView.reloadData()
    }
}

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeInfoCell") as! PokemonInfoCell
        if let pokemonDetail = pokemonDetail {
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Pokedex number"
                cell.infoLabel.text = pokemonDetail.id.description
            case 1:
                cell.titleLabel.text = "height"
                cell.infoLabel.text = pokemonDetail.height.description
            case 2:
                cell.titleLabel.text = "weight"
                cell.infoLabel.text = pokemonDetail.weight.description
            case 3:
                cell.titleLabel.text = "types"
                var types = ""
                for type in pokemonDetail.types {
                    types += "\(type.type.name) | "
                }
                cell.infoLabel.text = types
            case 4:
                cell.titleLabel.text = "moves"
                var moves = ""
                for move in pokemonDetail.moves {
                    moves += "\(move.move.name) | "
                }
                cell.infoLabel.text = moves
            case 5:
                cell.titleLabel.text = "abilities"
                var abilities = ""
                for ability in pokemonDetail.abilities {
                    abilities += "\(ability.ability.name) | "
                }
                cell.infoLabel.text = abilities
            default: break
            }
        }
        
        return cell
    }
}
