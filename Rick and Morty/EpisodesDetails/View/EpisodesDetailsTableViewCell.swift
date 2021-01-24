//
//  EpisodesDetailsTableViewCell.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/23/21.
//

import UIKit

class EpisodesDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var airdateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(episode: Episode) {
        episodeLabel.text = episode.episode
        nameLabel.text = episode.name
        airdateLabel.text = episode.airDate
    }
    
}
