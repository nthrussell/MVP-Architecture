//
//  UIImageView+Extension.swift
//  MVP-Architecture
//
//  Created by russel on 1/8/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func getImage(from url: URL) {
        kf.setImage(with: url)
    }
}
