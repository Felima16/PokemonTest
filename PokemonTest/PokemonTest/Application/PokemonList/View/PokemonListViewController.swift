//
//  PokemonListViewController.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 07/03/22.
//

import UIKit

class PokemonListViewController: UIViewController, SingleButtonDialogPresenter {
    
    enum Section {
        case main
    }
    
    let model = PokemonListViewModel()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, PokemonListViewModel.Pokemon>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokemons"
        setupBindable()
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }
    
    private func setupBindable() {
        model.showLoadingHud.bind { [weak self] visible in
            if let strongSelf = self {
                DispatchQueue.main.async {
                    visible ? strongSelf.view.startLoading() : strongSelf.view.stopLoading()
                }
            }
        }
        
        model.onShowAlert.bindAndFire { [weak self] alert in
            if let strongSelf = self {
                guard let alert = alert else { return }
                DispatchQueue.main.async {
                    strongSelf.presentSingleButtonDialog(alert: alert)
                }
            }
        }
        
        model.onShowPokemon.bindAndFire { [weak self] pokemons in
            guard self?.dataSource != nil, var snapshot = self?.dataSource.snapshot() else {
                return
            }

            snapshot.appendItems(pokemons)
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension PokemonListViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.init(named: "bluePokemon")
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PokemonCell, PokemonListViewModel.Pokemon> { (cell, indexPath, pokemon) in
            cell.pokemonNameLabel.text = pokemon.name
            cell.model.getPokemonDetail(url: pokemon.url)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PokemonListViewModel.Pokemon>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: PokemonListViewModel.Pokemon) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonListViewModel.Pokemon>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model.dataSourcePokemons())
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == model.getCountPokemon() - 1 {
            model.morePokemon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PokemonCell {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
            viewController.pokemonDetail = cell.model.pokemon
            viewController.pokemonImage = cell.model.pokemonImageData
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
