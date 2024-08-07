//
//  DetailViewController.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    var url: String
    var detailView: DetailView!
    var detailApiService: DetailApiService
    var detailStorageService: DetailStorageService
    var cancellable = Set<AnyCancellable>()
        
    init(url: String,
         detailApiService: DetailApiService = DefaultDetailApiService(),
         detailStorageService: DetailStorageService = DefaultDetailStorageService()
    ) {
        self.url = url
        self.detailApiService = detailApiService
        self.detailStorageService = detailStorageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        detailView = DetailView()
        self.view = detailView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callApi()
        observeOnTap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideProgressSpinner()
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.visibleViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    func observeOnTap() {
        detailView.onTap = { [weak self] data in
            guard let self = self else { return }
            self.detailStorageService.saveOrDelete(with: data)
        }
    }
    
    func checkIfPokemonIsInFavouriteList(data: PokemonDetailModel) {
        let data = detailStorageService.checkIfFavourite(data: data)
        detailView.favouriteButton.isSelected = data ? true : false
    }
    
    func callApi() {
        showProgressSpinner()
        detailApiService
            .fetchDetail(with: url)
            .receive(on: DispatchQueue.main)
            .sink { status in
                debugPrint("status is:\(status)")
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                detailView.updateUI(data: data)
                checkIfPokemonIsInFavouriteList(data: data)
                hideProgressSpinner()
            }
            .store(in: &cancellable)
    }
}
