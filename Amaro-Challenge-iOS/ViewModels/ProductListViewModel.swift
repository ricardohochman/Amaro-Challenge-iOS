//
//  ProductListViewModel.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class ProductListViewModel {
    
    // MARK: - Variables
    private var products = [ProductViewModel]()
    private var filteredProducts = [ProductViewModel]()
    private var isFiltering = false
    
    // MARK: - API
    func getProducts(completion: @escaping (Bool) -> Void) {
        AmaroServiceAPI.shared.fetchData(from: .products) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let productsResponse):
                self.products = productsResponse.products.map { ProductViewModel($0) }
                self.filteredProducts = self.products
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // MARK: - Data Source
    func numberOfProducts() -> Int {
        return filteredProducts.count
    }
    
    func product(at index: Int) -> ProductViewModel {
        return filteredProducts[index]
    }
    
    // MARK: - Filter
    func changeFilter() {
        isFiltering.toggle()
        if isFiltering {
            filteredProducts = products.filter { $0.inSale }
        } else {
            filteredProducts = products
        }
    }
    
    var filterNavigationImage: UIImage {
        return isFiltering ? #imageLiteral(resourceName: "icon-sale-selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "icon-sale.png").withRenderingMode(.alwaysOriginal)
    }
}
