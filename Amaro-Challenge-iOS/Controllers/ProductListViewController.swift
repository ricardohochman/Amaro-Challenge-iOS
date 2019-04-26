//
//  ProductListViewController.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class ProductListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Constants
    private let viewModel = ProductListViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getProducts()
    }
    
    // MARK: - Setups
    private func setupCollectionView() {
        collectionView.register(ProductCollectionViewCell.self)
    }
    
    // MARK: - API
    private func getProducts() {
        self.viewState = .loading
        viewModel.getProducts { [weak self] success in
            guard let self = self else { return }
            if success {
                self.viewState = .default
                self.collectionView.reloadData()
            } else {
                self.viewState = .error
            }
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
