//
//  PokemonCell.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 08/03/22.
//

import UIKit

class PokemonCell: UICollectionViewCell {

    let pokemonImageView = UIImageView()
    let pokemonNameLabel = UILabel()
    let model = PokemonCellViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindable()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func prepareForReuse() {
        pokemonImageView.image = nil
        pokemonNameLabel.text = nil
    }
    
    private func setupUI() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = .systemBackground
        pokemonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonNameLabel.textAlignment = .center
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonNameLabel)
        NSLayoutConstraint.activate([
            pokemonNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pokemonNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            pokemonNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: topAnchor),
            pokemonImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pokemonImageView.bottomAnchor.constraint(equalTo: pokemonNameLabel.topAnchor)
        ])
    }
    
    private func setupBindable() {
        model.showLoadingHud.bind { [weak self] visible in
            if let strongSelf = self {
                DispatchQueue.main.async {
                    visible ? strongSelf.contentView.startLoading() : strongSelf.contentView.stopLoading()
                }
            }
        }
        
        model.onShowImage.bindAndFire { [weak self] data in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.pokemonImageView.image = image
                }
            }
        }
    }
}
