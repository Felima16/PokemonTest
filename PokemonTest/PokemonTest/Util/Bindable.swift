//
//  Bindable.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 08/03/22.
//

class Bindable<T> {
    typealias Listener = ((T) -> Void)
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ val: T) {
        self.value = val
    }
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
