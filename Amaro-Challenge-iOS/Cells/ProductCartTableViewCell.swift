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
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!

    // MARK: - Variables
    private var viewModel: ProductViewModel?
    var didChangeCount: (() -> Void)?
    var didRemoveProduct: (() -> Void)?
    
    // MARK: - Life Cycle
    override func prepareForReuse() {
        mainImageView.image = nil
    }
    
    // MARK: - Setups
    func setup(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        mainImageView.setImage(url: viewModel.imagePath)
        nameLabel.text = viewModel.name
        actualPriceLabel.text = viewModel.actualPrice
        colorLabel.text = viewModel.color
        sizeLabel.text = viewModel.sizeSelected
        updateCountLayout()
    }
    
    @IBAction func minusButtonAction() {
        guard let viewModel = viewModel else { return }
        if viewModel.numberOfProducts == 1 {
            let alertController = UIAlertController(title: "Atenção", message: "Tem certeza que deseja remover o produto do carrinho", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Não", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Sim", style: .destructive) { _ in
                CartManager.shared.removeFromCart(viewModel)
                self.didRemoveProduct?()
            })
            UIApplication.topViewController()?.present(alertController, animated: true)
        } else {
            viewModel.changeProductsCount(.minus)
            didChangeCount?()
        }
        
        updateCountLayout()
    }
    
    @IBAction func plusButtonAction() {
        viewModel?.changeProductsCount(.plus)
        updateCountLayout()
        didChangeCount?()
    }
    
    private func updateCountLayout() {
        quantityLabel.text = String(viewModel?.numberOfProducts ?? 0)
    }

}
