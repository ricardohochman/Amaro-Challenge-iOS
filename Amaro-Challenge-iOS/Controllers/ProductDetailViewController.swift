//
//  ProductDetailViewController.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class ProductDetailViewController: BaseViewController {
    
    // MARK: - Constants
    private let viewModel: ProductViewModel
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var regularPriceLabel: UILabel!
    @IBOutlet private weak var actualPriceLabel: UILabel!
    @IBOutlet private weak var installmentsLabel: UILabel!
    
    // MARK: - Init
    
    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {
            self.containerView.alpha = 1
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
        if hitView != containerView {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Setups
    
    private func setupLayout() {
        image.setImage(url: viewModel.imagePath)
        discountLabel.text = viewModel.discount
        discountLabel.isHidden = !viewModel.inSale
        nameLabel.text = viewModel.name
        regularPriceLabel.attributedText = viewModel.regularPrice
        actualPriceLabel.text = viewModel.actualPrice
        actualPriceLabel.isHidden = !viewModel.showActualPrice
        installmentsLabel.text = viewModel.installments
    }
    
    // MARK: - Actions
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyProduct(_ sender: Any) {
        // TODO: Verificar se selecionou um tamanho
    }
}
