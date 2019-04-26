//
//  ProductCartTableViewCell.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class ProductCartTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: - Outlets
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var colorLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var actualPriceLabel: UILabel!
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        mainImageView.image = nil
    }
    
    // MARK: - Setups
    func setup(viewModel: ProductViewModel) {
        mainImageView.setImage(url: viewModel.imagePath)
        nameLabel.text = viewModel.name
        actualPriceLabel.text = viewModel.actualPrice
        colorLabel.text = viewModel.color
        sizeLabel.text = viewModel.sizeSelected
    }
}
