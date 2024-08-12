//
//  FavouriteViewController.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {

    var favouriteView = FavouriteView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "My Favourites"
        
        setupPresenter()
        
        let didSaveNotification = NSManagedObjectContext.didSaveObjectsNotification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewEntrySaved),
                                               name: didSaveNotification,
                                               object: nil)
    }
    
    override func loadView() {
        self.view = favouriteView
    }
    
    private func setupPresenter() {
        let presenter = FavouritePresenter(favouriteView: favouriteView)
        favouriteView.presenter = presenter
    }
    
    @objc func didNewEntrySaved() {
        favouriteView.presenter.getAllFavourites()
    }
}
