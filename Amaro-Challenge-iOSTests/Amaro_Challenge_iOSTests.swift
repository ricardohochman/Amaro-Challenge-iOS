//
//  Amaro_Challenge_iOSTests.swift
//  Amaro-Challenge-iOSTests
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import XCTest
@testable import Amaro_Challenge_iOS

class Amaro_Challenge_iOSTests: XCTestCase {

    var product: Product!
    var viewModel: ProductViewModel!
    var cartManager: CartManager!
    var sut: ProductDetailViewController!
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "ProductMock", withExtension: "json") else {
            XCTFail("Missing file: ProductMock.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let product = try decoder.decode(Product.self, from: data)
            self.product = product
        } catch {
            XCTFail("Failed to convert json to Product")
        }
        
        viewModel = ProductViewModel(product)
        cartManager = CartManager.shared
        sut = ProductDetailViewController(viewModel: viewModel)
        sut.loadView()
        sut.viewDidLoad()
        UIApplication.shared.keyWindow?.rootViewController = sut
    }

    override func tearDown() {
        cartManager.clearAll()
    }

    func testViewModel() {
        XCTAssertEqual(viewModel.name, "VESTIDO TRANSPASSE BOW")
        XCTAssertNotEqual(viewModel.imagePath, "")
    }
    
    func testDetailViewController() {
        XCTAssertEqual(sut.discountLabel.text, viewModel.discount)
        XCTAssertEqual(sut.nameLabel.text, viewModel.name)
        XCTAssertEqual(sut.regularPriceLabel.attributedText, viewModel.regularPrice)
        XCTAssertEqual(sut.installmentsLabel.text, viewModel.installments)
        XCTAssertEqual(sut.sizeCollectionView.numberOfItems(inSection: 0), viewModel.sizes.count)
    }
    
    func testCart() {
        XCTAssertEqual(cartManager.numberOfProducts(), 0)
        cartManager.addToCart(viewModel)
        XCTAssertEqual(cartManager.numberOfProducts(), 1)
    }
    
    func testAlertPresented() {
        sut.buyProduct()
        XCTAssertTrue(sut.presentedViewController is UIAlertController)
        XCTAssertEqual(cartManager.numberOfProducts(), 0)
        XCTAssertNotEqual(cartManager.numberOfProducts(), 1)
    }

    func testAlertNotPresented() {
        viewModel.selectedSizeIndexPath = IndexPath(row: 0, section: 0)
        sut.buyProduct()
        XCTAssertFalse(sut.presentedViewController is UIAlertController)
        XCTAssertNotEqual(cartManager.numberOfProducts(), 0)
        XCTAssertEqual(cartManager.numberOfProducts(), 1)
    }
}
