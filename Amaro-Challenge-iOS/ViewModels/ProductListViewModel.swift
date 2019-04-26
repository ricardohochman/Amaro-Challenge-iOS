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

class ProductViewModel {
    // MARK: - Constants
    let product: Product
    
    // MARK: - Variables
    var selectedSizeIndexPath: IndexPath?
    var numberOfProducts = 0

    // MARK: - Init
    init(_ product: Product) {
        self.product = product
    }
    
    var name: String {
        return product.name
    }
    
    var imagePath: String {
        return product.image
    }
    
    var regularPrice: NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: product.regularPrice)
        if inSale {
            attributeString.addAttributes(
                [.font: UIFont.systemFont(ofSize: 15),
                 .strikethroughStyle: NSUnderlineStyle.single.rawValue],
                range: NSRange(location: 0, length: attributeString.length))
        } else {
            attributeString.addAttributes(
                [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)],
                range: NSRange(location: 0, length: attributeString.length))
        }
        return attributeString
    }
    
    var actualPrice: String {
        return product.actualPrice
    }
    
    var showActualPrice: Bool {
        return inSale
    }
    
    var inSale: Bool {
        return product.regularPrice != product.actualPrice
    }
    
    var discount: String {
        return product.discountPercentage
    }
    
    var installments: String {
        return product.installments
    }
    
    var sizes: [Size] {
        return product.sizes.filter { $0.available }
    }
    
    var sizeSelected: String {
        return "Tamanho: \(sizes[selectedSizeIndexPath?.row ?? 0].size)"
    }
    
    var color: String {
        return "Cor: \(product.color)"
    }
    
    func addToCart() {
        numberOfProducts += 1
        CartManager.shared.addToCart(self)
    }
    
    var priceDouble: Double {
        var price = product.actualPrice.filter("01234567890.,".contains)
        price = price.replacingOccurrences(of: ",", with: ".")
        return Double(price) ?? 0.0
    }
    
    func clearProduct() {
        numberOfProducts = 0
        selectedSizeIndexPath = nil
    }
}

extension ProductViewModel: Equatable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        return lhs.product == rhs.product
    }
}
