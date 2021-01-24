//
//  EpisodesDetailsViewController.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/23/21.
//

import UIKit
import Combine

class EpisodesDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let cellIdentifier = "EpisodesDetailsTableViewCell"
    var url: String = "https://rickandmortyapi.com/api/episode/"
    var viewModel: EpisodesDetailsViewModel?
    var subscribtion = Set<AnyCancellable>()
    var episodesURLs = [String]() {
        didSet {
            for episode in episodesURLs {
                let lastChars = "," + "" + String(episode.dropFirst(40))
                url += lastChars
            }
            viewModel = EpisodesDetailsViewModel(url: url)
        }
    }
    
    var episodes: Episodes? {
        didSet {
            guard episodes != nil else { return }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubscribtion()
        configureTableView()
        viewModel?.getData()
        
    }
    
    func setSubscribtion() {
        subscribtion = [
            viewModel!.$episodes.assign(to: \.episodes, on: self),
            viewModel!.$episodes.sink(receiveValue: { (episodes) in
                self.title = String(episodes?.count ?? 0) + " Episodes"
            })
        ]
    }
    
    
    func configureTableView() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    

    static func storyboardInstance() -> EpisodesDetailsViewController? {
        let storyboard = UIStoryboard(name: "EpisodesDetails", bundle: nil)
        return storyboard.instantiateInitialViewController() as? EpisodesDetailsViewController
    }

}

extension EpisodesDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EpisodesDetailsTableViewCell
        let episode = self.episodes![indexPath.row]
        cell.configureCell(episode: episode)
        return cell
    }
    
    
}
