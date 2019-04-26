//
//  ProductCollectionViewCell.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, ReusableView {
    
    // MARK: - Outlets
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var regularPriceLabel: UILabel!
    @IBOutlet private weak var actualPriceLabel: UILabel!
    @IBOutlet private weak var installmentsLabel: UILabel!
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        image.image = nil
    }
    
    // MARK: - Setups
    func setup(viewModel: ProductViewModel) {
        image.setImage(url: viewModel.imagePath)
        discountLabel.text = viewModel.discount
        discountLabel.isHidden = !viewModel.inSale
        nameLabel.text = viewModel.name
        regularPriceLabel.attributedText = viewModel.regularPrice
        actualPriceLabel.text = viewModel.actualPrice
        actualPriceLabel.isHidden = !viewModel.showActualPrice
        installmentsLabel.text = viewModel.installments
    }
}
