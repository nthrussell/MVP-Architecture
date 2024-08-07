//
//  FavouriteViewController.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {

    var favouriteView: FavouriteView!
    private var favouriteStorageService: FavouriteStorageService
    
    init(favouriteStorageService: FavouriteStorageService = DefaultFavouriteStorageService()) {
        self.favouriteStorageService = favouriteStorageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "My Favourites"
        
        let didSaveNotification = NSManagedObjectContext.didSaveObjectsNotification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewEntrySaved),
                                               name: didSaveNotification,
                                               object: nil)
    }
    
    override func loadView() {
        favouriteView = FavouriteView()
        self.view = favouriteView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllFavourites()
        deleteFavourite()
    }
    
    @objc func didNewEntrySaved() {
        getAllFavourites()
    }
    
    func getAllFavourites() {
        let allData = favouriteStorageService.getAllFavourites()
        favouriteView.detailData = allData
        favouriteView.tableView.reloadData()
    }
    
    func deleteFavourite() {
        favouriteView.tapDelete = { [weak self] data in
            guard let self = self else { return }
            favouriteStorageService.delete(data: data)
        }
    }
}
