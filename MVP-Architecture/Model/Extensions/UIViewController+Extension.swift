//
//  UIViewController+Extension.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import SVProgressHUD

extension UIViewController {
    func showProgressSpinner() {
        SVProgressHUD.show()
    }
    
    func hideProgressSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
