//
//  CharacterViewController.swift
//  Rick and Morty
//
//  Created by Marwan Osama on 1/21/21.
//

import UIKit
import Alamofire
import ChameleonFramework
import Combine
import SDWebImage

class CharacterViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    private let cellIdentifier = "CharacterCollectionViewCell"
    @Published var searchText: String?
    let viewModel = CharacterViewModel()
    var subscribtion = Set<AnyCancellable>()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        sb.placeholder = "Enter character name..."
        sb.layer.cornerRadius = 10
        sb.delegate = self
        sb.autocapitalizationType = .none
        return sb
    }()

    var dataArray = [Result]() {
        didSet {
            if !dataArray.isEmpty {
                self.characterCollectionView.reloadData()
            }
        }
    }
    
    var errorMessage: String? {
        didSet {
            guard errorMessage != nil else { return }
            print(errorMessage!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        setSubscribtion()
        viewModel.getData(pagination: false)
    }
    

    static func storyboardInstance() -> CharacterViewController? {
        let storyboard = UIStoryboard(name: "Character", bundle: nil)
        return storyboard.instantiateInitialViewController() as? CharacterViewController
    }
    
    func setSubscribtion() {
        self.subscribtion = [
            viewModel.$finalResult.assign(to: \.dataArray, on: self),
            viewModel.$contentViewAlpha.assign(to: \.alpha, on: contentView),
            viewModel.$errorMessage.assign(to: \.errorMessage, on: self),
            viewModel.$isLoading.sink(receiveValue: {
                if $0 {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }),
            $searchText.assign(to: \.searchText, on: viewModel)
        ]
    }
    
    
    func configureNavigationBar() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showSearchbar))
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    
    @objc func showSearchbar() {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(hideSearchbar))
        navigationItem.rightBarButtonItems = [button]
        navigationItem.titleView = searchBar

    }
    
    @objc func hideSearchbar() {
        configureNavigationBar()
        navigationItem.titleView = nil
    }

    func configureCollectionView() {
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.frame.width/2-4.5, height: self.view.frame.width/2-4.5)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 3, bottom: 0, right: 3)
        characterCollectionView.setCollectionViewLayout(layout, animated: true)
        characterCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }

}

extension CharacterViewController: UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        self.searchText = text
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CharacterCollectionViewCell
        let result = self.dataArray[indexPath.row]
        cell.configureCell(characterResult: result)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characterSelected = self.dataArray[indexPath.row]
        let characterDetailsVC = CharacterDetailsViewController.storyboardInstance()
        characterDetailsVC?.details = characterSelected
        self.navigationController?.pushViewController(characterDetailsVC!, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard searchText == nil || searchText == "" else { return }
        guard !viewModel.url.isEmpty else { return }
        let position = scrollView.contentOffset.y
        let contentSize = characterCollectionView.contentSize.height
        if position > contentSize - scrollView.frame.size.height {
            guard !viewModel.isGettingData else { return }
            viewModel.getData(pagination: true)
            print("Fetch more")
        }
    }
}

