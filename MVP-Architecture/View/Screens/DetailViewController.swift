//
//  DetailViewController.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var url: String
    var detailView = DetailView()
        
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Loader.show()
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPresenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Loader.hide()
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.visibleViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    private func setupPresenter() {
        let presenter = DetailPresenter(url: url, detailview: detailView)
        detailView.presenter = presenter
    }
}
