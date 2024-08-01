//
//  FavouriteViewCell.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit

class FavouriteViewCell: UITableViewCell {
    static let identifier = "\(FavouriteViewCell.self)"
    
    private(set) lazy var cellContainerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var cellImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var nameLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellContainerView)
        cellContainerView.addSubview(cellImageView)
        cellContainerView.addSubview(nameLabel)
        
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            cellContainerView.topAnchor.constraint(equalTo: topAnchor),
            cellContainerView.leftAnchor.constraint(equalTo: leftAnchor),
            cellContainerView.rightAnchor.constraint(equalTo: rightAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cellImageView.leftAnchor.constraint(equalTo: cellContainerView.leftAnchor, constant: 16),
            cellImageView.heightAnchor.constraint(equalToConstant: 45),
            cellImageView.widthAnchor.constraint(equalToConstant: 45),
            cellImageView.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 4),
            nameLabel.rightAnchor.constraint(equalTo: cellContainerView.rightAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.centerYAnchor.constraint(equalTo: cellContainerView.centerYAnchor)
        ])
    }
}
