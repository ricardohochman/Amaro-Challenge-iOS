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
    @IBOutlet private weak var sizeCollectionView: UICollectionView!
    
    // MARK: - Init
    
    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerView.alpha = 0
        self.containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseInOut, animations: {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
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
        discountLabel.isHidden = !viewModel.onSale
        nameLabel.text = viewModel.name
        regularPriceLabel.attributedText = viewModel.regularPrice
        actualPriceLabel.text = viewModel.actualPrice
        actualPriceLabel.isHidden = !viewModel.showActualPrice
        installmentsLabel.text = viewModel.installments
    }
    
    private func setupCollectionView() {
        sizeCollectionView.register(SizeCollectionViewCell.self)
    }
    
    // MARK: - Actions
    
    @IBAction func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyProduct(_ sender: Any) {
        if viewModel.selectedSizeIndexPath == nil {
            self.showAlert(title: "Selecione um tamanho", message: "É necessário selecionar um tamanho para adicionar o produto ao carrinho.")
            return
        }
        
        viewModel.addToCart()
        closeView()
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SizeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(size: viewModel.sizes[indexPath.row])
        if let selectedSizeIndexPath = viewModel.selectedSizeIndexPath {
            let isSelected = selectedSizeIndexPath == indexPath
            cell.setSelected(value: isSelected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell else { return }
        if let currentIndex = viewModel.selectedSizeIndexPath, let cellSelected = collectionView.cellForItem(at: currentIndex) as? SizeCollectionViewCell {
            cellSelected.setSelected(value: false)
        }
        
        viewModel.selectedSizeIndexPath = indexPath
        cell.setSelected(value: true)
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = 40
        let cellCount = collectionView.numberOfItems(inSection: 0)
        let cellSpacing = 10
        let collectionViewWidth = collectionView.frame.width
        
        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: leftInset)
    }
}
