//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/10/30.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var TMDBObjects: [TMDBObject] = [TMDBObject]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TMDBObejectTableViewCell.self, forCellReuseIdentifier: TMDBObejectTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTable.frame = view.bounds
        
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let TMDBObjects):
                self?.TMDBObjects = TMDBObjects
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TMDBObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TMDBObejectTableViewCell.identifier, for: indexPath) as? TMDBObejectTableViewCell else {
            return UITableViewCell()
        }
        
        let TMDBObject = TMDBObjects[indexPath.row]
        cell.configure(with: TMDBObjectViewModel(titleName: TMDBObject.original_title ?? "Unknown title name", posterURL: TMDBObject.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
