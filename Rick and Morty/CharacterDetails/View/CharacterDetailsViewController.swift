//
//  CharacterDetailsViewController.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/22/21.
//

import UIKit
import ChameleonFramework
import SDWebImage

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var details: Result?
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
    }
    
    func configureNavigation() {
        title = "Character Details"
        navigationController?.navigationBar.tintColor = .label
    }
    
    func configureUI() {
        characterImageView.layer.cornerRadius = characterImageView.frame.height/2
        characterImageView.layer.borderWidth = 1
        characterImageView.layer.borderColor = UIColor.label.cgColor
        guard let details = self.details else { return }
        let url = URL(string: details.image)
        characterImageView.sd_setImage(with: url)
        nameLabel.text = "Name: \(details.name)"
        statusLabel.text = "Status: \(details.status.rawValue)"
        speciesLabel.text = "Species: \(details.species)"
        if details.type == "" {
            typeLabel.text = "Type: Unknown"
        } else {
            typeLabel.text = "Type: \(details.type)"
        }
        genderLabel.text = "Gender: \(details.gender)"
        originLabel.text = details.origin.name
        locationLabel.text = details.location.name
        episodesLabel.text = "\(details.episode.count)"
        createdAtLabel.text = "Created at: \(details.created)"
        
    }
    
    static func storyboardInstance() -> CharacterDetailsViewController? {
        let storyboard = UIStoryboard(name: "CharacterDetails", bundle: nil)
        return storyboard.instantiateInitialViewController() as? CharacterDetailsViewController
    }
    
    
    @IBAction func locationOriginButtonTapped(_ sender: UIButton) {
        guard let originURL = self.details?.origin.url else { return }
        guard let locationURL = self.details?.location.url else { return }
        let locationVC = CharacterLocationViewController.storyboardInstance()
        locationVC?.locationURL = sender.tag == 0 ? originURL : locationURL
        self.navigationController?.pushViewController(locationVC!, animated: true)
        
    }
    
    
    
    @IBAction func episodesButtonTapped(_ sender: UIButton) {
        guard let episodesURLS = self.details?.episode else { return }
        let episodesVC = EpisodesDetailsViewController.storyboardInstance()
        episodesVC?.episodesURLs = episodesURLS
        self.navigationController?.pushViewController(episodesVC!, animated: true)
        
    }
    
    
    


}
