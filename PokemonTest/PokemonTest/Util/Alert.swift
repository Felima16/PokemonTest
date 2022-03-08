//
//  Alert.swift
//  PokemonTest
//
//  Created by Fernanda de Lima on 08/03/22.
//

import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
