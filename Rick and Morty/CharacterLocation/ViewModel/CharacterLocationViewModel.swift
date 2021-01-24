//
//  CharacterLocationViewModel.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/23/21.
//

import UIKit
import Combine
import Alamofire

class CharacterLocationViewModel {
    
    var locationURL: String?
    var residentURL: String = "https://rickandmortyapi.com/api/character/"
    
    
    var residentsURls: [String]? {
        didSet {
            for url in residentsURls! {
                let lastChars = String(url.dropFirst(42))
                residentURL += "," + lastChars
            }
            print(residentURL)
            self.getResidents()
        }
    }
    
    @Published var residents: [Result] = [Result]()
    @Published var characterLocation: CharacterLocation?
    @Published var contentViewAlpha: CGFloat = 0
    
    
    init(url: String) {
        self.locationURL = url
    }
    
    func getData() {
        self.contentViewAlpha = 0
        APIService.shared.fetchData(url: locationURL!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (location: CharacterLocation?, err) in
            guard let self = self else { return }
            if let err = err {
                print(err)
            } else {
                guard let location = location else { return }
                self.characterLocation = location
                self.residentsURls = location.residents
            }
        }
    }
    
    func getResidents() {
        APIService.shared.fetchData(url: residentURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (residents: [Result]?, err) in
            guard let self = self else { return }
            if let err = err {
                print(err)
            } else {
                guard let residents = residents else { return }
                self.residents = residents
                self.contentViewAlpha = 1
            }
        }
        
    }
    
    
}
