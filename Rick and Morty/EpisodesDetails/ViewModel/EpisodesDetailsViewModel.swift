//
//  EpisodesDetailsViewModel.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/23/21.
//

import Foundation
import Alamofire
import Combine

class EpisodesDetailsViewModel {
    
    var url: String?
    
    @Published var episodes: Episodes?
    
    init(url: String) {
        self.url = url
    }
    
    
    func getData() {
        print(url!)
        APIService.shared.fetchData(url: url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (episodes: Episodes?, err) in
            guard let self = self else { return }
            if let err = err {
                print(err)
            } else {
                guard let episodes = episodes else { return }
                self.episodes = episodes
            }
        }
    }
    
    
}
