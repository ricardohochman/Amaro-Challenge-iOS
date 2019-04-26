//
//  CartManager.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}
    private var products = [ProductViewModel]()
    
    func addToCart(_ product: ProductViewModel) {
        product.numberOfProducts += 1
        if !products.contains(where: { $0.product == product.product && $0.selectedSizeIndexPath == product.selectedSizeIndexPath }) {
            products.append(product)
        }
    }
    
    func removeFromCart(_ product: ProductViewModel) {
        product.clearProduct()
        products.remove(object: product)
    }
    
    // MARK: - Data Source
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func product(at index: Int) -> ProductViewModel {
        return products[index]
    }
    
    func clearAll() {
        products.forEach { $0.clearProduct() }
        products.removeAll()
    }
    
    var totalPrice: String {
        let price = products.reduce(0, { $0 + (Double($1.numberOfProducts) * ($1.priceDouble)) })
        return price.toBrazilianCurrency() ?? ""
    }
}
