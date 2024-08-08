//
//  FavouriteView.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit

class FavouriteView: UIView {
    
    private(set) lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavouriteViewCell.self, forCellReuseIdentifier: FavouriteViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var tapDelete: ((_ model: PokemonDetailModel) -> Void)?
    var presenter: FavouritePresenter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(tableView)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavouriteView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.detailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavouriteViewCell.identifier,
            for: indexPath
        ) as! FavouriteViewCell
        
        guard let presenter = presenter else { return cell }
        let data = presenter.detailData[indexPath.row]
        
        if let url = data.sprites.frontDefault, (url != "") {
            cell.cellImageView.getImage(from: URL(string: url)!)
        }
        cell.nameLabel.text = data.name
        
        return cell
    }
}

extension FavouriteView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = presenter.detailData[indexPath.row]
            if let tapDelete = tapDelete {
                tapDelete(data)
            }
        }
    }
}
