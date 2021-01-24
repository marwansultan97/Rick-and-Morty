//
//  CharacterLocationViewController.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/23/21.
//

import UIKit
import Combine

class CharacterLocationViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var residentsNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    

    var subscribtion = Set<AnyCancellable>()
    var viewModel: CharacterLocationViewModel?
    
    
    let cellIdentifier = "CharacterLocationTableViewCell"
    
    var locationURL: String? {
        didSet {
            viewModel = CharacterLocationViewModel(url: locationURL!)
        }
    }
    
    var characterLocation: CharacterLocation?
    var residents = [Result]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Planet Details"
        setSubscribtion()
        configureTableView()
        viewModel?.getData()
    }
    
    func setSubscribtion() {
        self.subscribtion = [
            viewModel!.$characterLocation.sink(receiveValue: {
                self.nameLabel.text = $0?.name
                self.typeLabel.text = $0?.type
                self.dimensionLabel.text = $0?.dimension
                self.residentsNumber.text = String(($0?.residents.count ?? 0))
            }),
            viewModel!.$residents.assign(to: \.residents, on: self),
            viewModel!.$contentViewAlpha.assign(to: \.alpha, on: contentView)
        ]
    }

    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        
    }
    
    static func storyboardInstance() -> CharacterLocationViewController? {
        let storyboard = UIStoryboard(name: "CharacterLocation", bundle: nil)
        return storyboard.instantiateInitialViewController() as? CharacterLocationViewController
    }

}

extension CharacterLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let resident = self.residents[indexPath.row]
        cell.textLabel?.text = resident.name
        return cell
    }
    
    
}
