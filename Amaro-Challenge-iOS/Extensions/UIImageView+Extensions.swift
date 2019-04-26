//
//  UIImageView+Extensions.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(url: String) {
        AmaroServiceAPI.shared.getImage(url: url) { result in
            if case .success(let image) = result {
                self.image = image
            }
        }
    }
}
