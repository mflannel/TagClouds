//
//  Model.swift
//  TagCloud
//
//  Created by Никита Комаров on 01.04.2022.
//

import Foundation

// MARK: - Массив структур с данными о напитках
struct Drinks: Codable {
    var drinks: [Drink]
}

struct Drink: Codable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}
