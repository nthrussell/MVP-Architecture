//
//  HomeViewCell.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit

class HomeViewCell: UITableViewCell {
    static let identifier = "\(HomeViewCell.self)"
    
    private(set) lazy var cellContainerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
            cellContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: cellContainerView.leftAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: cellContainerView.rightAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor)
        ])
    }

}
