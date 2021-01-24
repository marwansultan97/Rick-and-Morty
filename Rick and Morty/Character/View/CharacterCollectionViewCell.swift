//
//  CharacterCollectionViewCell.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/21/21.
//

import UIKit
import ChameleonFramework

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(characterResult: Result) {
        self.characterImageView.sd_setImage(with: URL(string: characterResult.image)) { (image, err, imagecache, url) in
            self.backgroundColor = AverageColorFromImage(image: image ?? UIImage())
            self.characterNameLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn: self.backgroundColor, isFlat: true)
        }
        self.characterNameLabel.text = characterResult.name
        self.characterNameLabel.adjustsFontSizeToFitWidth = true
    }

}
