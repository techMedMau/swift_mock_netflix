//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/10/30.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var TMDBObjects: [TMDBObject] = [TMDBObject]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TMDBObejectTableViewCell.self, forCellReuseIdentifier: TMDBObejectTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or a tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        
        fetchDiscoverMovies()
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let TMDBObjects):
                self?.TMDBObjects = TMDBObjects
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTable.frame = view.bounds
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TMDBObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TMDBObejectTableViewCell.identifier, for: indexPath) as? TMDBObejectTableViewCell else {
            return UITableViewCell()
        }
        
        let TMDBObject = TMDBObjects[indexPath.row]
        let TMDBObjectViewModel = TMDBObjectViewModel(titleName: TMDBObject.original_title ?? "Unknown title name", posterURL: TMDBObject.poster_path ?? "")
        cell.configure(with: TMDBObjectViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
