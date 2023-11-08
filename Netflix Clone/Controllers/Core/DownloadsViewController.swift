//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/10/30.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var TMDBObjects: [TMDB] = [TMDB]()
    
    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(TMDBObejectTableViewCell.self, forCellReuseIdentifier: TMDBObejectTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        view.addSubview(downloadedTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchingTMDBsFromDataBase { [weak self] result in
            switch result {
            case .success(let TMDBs):
                self?.TMDBObjects = TMDBs
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: TMDBObjects[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from the DB")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.TMDBObjects.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let TMDBObject = TMDBObjects[indexPath.row]
        
        guard let TMDBObjectName = TMDBObject.original_title ?? TMDBObject.original_name else { return }
        
        APICaller.shared.getMovie(with: TMDBObjectName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TMDBObjectPreviewViewController()
                    vc.configure(with: TMDBObjectPreviewViewModel(title: TMDBObjectName, youtubeView: videoElement, tileOverview: TMDBObject.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
