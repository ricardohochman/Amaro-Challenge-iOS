//
//  ProductListViewModel.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import Foundation

class ProductListViewModel {
    
    // MARK: - Variables
    private var products = [ProductViewModel]()
    
    // MARK: - API
    func getProducts(completion: @escaping (Bool) -> Void) {
        AmaroServiceAPI.shared.fetchData(from: .products) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let productsResponse):
                self.products = productsResponse.products.map { ProductViewModel($0) }
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // MARK: - Data Source
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func product(at index: Int) -> ProductViewModel {
        return products[index]
    }
    
}

class ProductViewModel {
    // MARK: - Constants
    let product: Product
    
    // MARK: - Init
    init(_ product: Product) {
        self.product = product
    }
}
