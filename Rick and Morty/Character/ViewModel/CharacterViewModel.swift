//
//  CharacterViewModel.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/21/21.
//

import Foundation
import Alamofire
import Combine


class CharacterViewModel {
    
    var isGettingData: Bool = false
    
    var searchText: String? {
        didSet {
            guard searchText != nil else { return }
            print("DEBUG \(searchText!)")
            self.searchChar()
        }
    }
    
    
    var url = "https://rickandmortyapi.com/api/character"
    
    @Published var character: Character?
    @Published var finalResult: [Result] = [Result]()
    @Published var isLoading: Bool = false
    @Published var contentViewAlpha: CGFloat = 0
    @Published var errorMessage: String?
    
    
    var allResults: [Result] = [Result]()
    
    func getData(pagination: Bool) {
        if !pagination {
            self.isLoading = true
            self.contentViewAlpha = 0
        } else if pagination {
            isGettingData = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            APIService.shared.fetchData(url: self.url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (character: Character?, err) in
                guard let self = self else { return }
                self.isLoading = false
                if pagination {
                    self.isGettingData = false
                }
                print("Getting Data")
                if let err = err {
                    print(err)
                    self.errorMessage = err.localizedDescription
                } else {
                    guard let character = character else { return }
                    self.url = character.info.next ?? ""
                    print(self.url)
                    self.character = character
                    self.finalResult.append(contentsOf: character.results)
                    self.allResults.append(contentsOf: character.results)
                    self.contentViewAlpha = 1
                }
            }

        }
    }
    
    func searchChar() {
        if searchText == "" {
            self.finalResult = allResults
        } else {
            let text = searchText?.lowercased()
            self.finalResult = allResults.filter { $0.name.lowercased().contains("\(text!)") }
        }
        
    }
    
}
