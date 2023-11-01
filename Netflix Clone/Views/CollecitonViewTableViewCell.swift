//
//  CollecitonViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/10/31.
//

import UIKit

class CollecitonViewTableViewCell: UITableViewCell {

    static let identifier = "CollecitonViewTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
}
