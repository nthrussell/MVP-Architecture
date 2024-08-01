//
//  HomeViewController.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var homeView: HomeView!
    var homeApiService: HomeApiService
    var cancellable = Set<AnyCancellable>()
    var hasDataLoaded = false
    
    init(homeApiService: HomeApiService = DefaultHomeApiService()) {
        self.homeApiService = homeApiService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "Pokedex"
    }
    
    override func loadView() {
        homeView = HomeView()
        self.view = homeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callApi()
        fetchMoreData()
        navigate()
    }
    
    func callApi() {
        if hasDataLoaded { return }
        homeApiService.fetchPokemonList(offset: homeView.pokemonList.count)
            .sink { status in
                debugPrint("status is:\(status)")
            } receiveValue: { [weak self] payload in
                guard let self = self else { return }
                homeView.pokemonList.append(contentsOf: payload.results)
                homeView.reloadTebleView()
                hasDataLoaded = true
            }
            .store(in: &cancellable)
    }
    
    func fetchMoreData() {
        homeView.fetchMoreData = { [weak self] in
            guard let self = self else { return }
            hasDataLoaded = false
            callApi()
        }
    }
    
    func navigate() {
        homeView.onTap = { [weak self] url in
            guard let self = self else { return }
            let vc = DetailViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
