//
//  UIViewController+Extension.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import SVProgressHUD

class Loader {
    static func show() {
        SVProgressHUD.show()
    }
    
    static func hide() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
