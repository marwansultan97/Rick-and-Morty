//
//  CharacterLocationModel.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/23/21.
//

import Foundation

// MARK: - CharacterLocation
struct CharacterLocation: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
