//
//  HomeView.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit

class HomeView: UIView {
    private(set) lazy var searchBar:UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.searchBarStyle = .default
        searchbar.delegate = self
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    private(set) lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: HomeViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) lazy var activityindicatorView:UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: .medium)
        aiView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45)
        aiView.translatesAutoresizingMaskIntoConstraints = true
        return aiView
    }()
    
    var onTap: ((_ url:String) -> Void)?
    
    var presenter: HomePresenter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(searchBar)
        addSubview(tableView)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadTebleView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeViewCell.identifier,
            for: indexPath
        ) as! HomeViewCell
        
        let data = presenter.rowAt(indexPath: indexPath)
        cell.nameLabel.text = data.name
        
        if (indexPath.row == presenter.pokemonList.count - 1) && (!presenter.isFiltering){
            tableView.tableFooterView = activityindicatorView
            activityindicatorView.startAnimating()
            presenter.fetchMoreData()
        }
        
        if presenter.isFiltering { activityindicatorView.stopAnimating() }
        
        return cell
    }
}

extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = presenter.rowAt(indexPath: indexPath)

        if let onTap = onTap {
            onTap(data.url)
        }
    }
}

extension HomeView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        presenter.filterData(with: textSearched)
    }
}
