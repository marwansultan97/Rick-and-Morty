//
//  EpisodesDetailsModel.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/23/21.
//

import Foundation

// MARK: - Episode
struct Episode: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}

typealias Episodes = [Episode]
