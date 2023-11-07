//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/11/4.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func SearchResultsViewControllerDidTapItem(_ viewModel: TMDBObjectPreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var TMDBObjects: [TMDBObject] = [TMDBObject]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TMDBCollectionViewCell.self, forCellWithReuseIdentifier: TMDBCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TMDBObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else { return UICollectionViewCell() }
        
        let TMDBObject = TMDBObjects[indexPath.row]
        
        cell.configure(with: TMDBObject.poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let TMDBObject = TMDBObjects[indexPath.row]
        guard let TMDBObjectName = TMDBObject.original_title ?? TMDBObject.original_name else { return }
        
        APICaller.shared.getMovie(with: TMDBObjectName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.SearchResultsViewControllerDidTapItem(TMDBObjectPreviewViewModel(title: TMDBObject.original_title ?? "", youtubeView: videoElement, tileOverview: TMDBObject.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
