//
//  ViewController.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AmaroServiceAPI.shared.fetchData(from: .products) { result in
            switch result {
            case .success(let products):
                print(products)
            case .failure(let error):
                print("error", error)
            }
        }
    }


}

