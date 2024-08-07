//
//  HomeViewController.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "Pokedex"
        setupPresenter()
    }
    
    override func loadView() {
        self.view = homeView
    }
    
    private func setupPresenter() {
        let presenter = HomePresenter(homeView: homeView)
        homeView.presenter = presenter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigate()
    }
    
    func navigate() {
        homeView.onTap = { [weak self] url in
            guard let self = self else { return }
            let vc = DetailViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
