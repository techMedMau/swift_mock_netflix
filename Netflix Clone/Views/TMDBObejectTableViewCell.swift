//
//  TMDBObejectTableViewCell.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/11/4.
//

import UIKit

class TMDBObejectTableViewCell: UITableViewCell {

    static let identifier = "TMDBObejectTableViewCell"
    
    private let TMDBObjectPlayButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        
        return button
    }()
    
    private let TMDBObjectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let TMDBObjectPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(TMDBObjectPosterUIImageView)
        contentView.addSubview(TMDBObjectLabel)
        contentView.addSubview(TMDBObjectPlayButton)
        
        applyConstraints()
    }
    
//    style for image, label & button
    private func applyConstraints() {
        let TMDBObjectPosterUIImageViewConstraints = [
            TMDBObjectPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            TMDBObjectPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            TMDBObjectPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            TMDBObjectPosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let TMDBObjectLabelConstraints = [
            TMDBObjectLabel.leadingAnchor.constraint(equalTo: TMDBObjectPosterUIImageView.trailingAnchor, constant: 20),
            TMDBObjectLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let TMDBObjectPlayButtonConstraints = [
            TMDBObjectPlayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            TMDBObjectPlayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(TMDBObjectPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(TMDBObjectLabelConstraints)
        NSLayoutConstraint.activate(TMDBObjectPlayButtonConstraints)
        
    }
    
    public func configure(with TMDBObject: TMDBObjectViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(TMDBObject.posterURL)") else { return }
        
        TMDBObjectPosterUIImageView.sd_setImage(with: url, completed: nil)
        TMDBObjectLabel.text = TMDBObject.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
