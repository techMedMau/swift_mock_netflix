//
//  CollecitonViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/10/31.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TMDBObjectPreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollecitonViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var TMDBObjects: [TMDBObject] = [TMDBObject]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TMDBCollectionViewCell.self, forCellWithReuseIdentifier: TMDBCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with TMDBObjects: [TMDBObject]) {
        self.TMDBObjects = TMDBObjects
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else {return UICollectionViewCell()}
        
        guard let model = TMDBObjects[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TMDBObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let TMDBObject = TMDBObjects[indexPath.row]
        guard let TMDBObjectName = TMDBObject.original_title ?? TMDBObject.original_name else { return }
        
        APICaller.shared.getMovie(with: TMDBObjectName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElemnet):
                let TMDBObject = self?.TMDBObjects[indexPath.row]
                guard let TMDBObjectOverview = TMDBObject?.overview else { return }
                guard let strongSelf = self else { return }
                let viewModel = TMDBObjectPreviewViewModel(title: TMDBObjectName, youtubeView: videoElemnet, tileOverview: TMDBObjectOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
