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
    
    // MARK: - Variables
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setups
    
    private func setupNavigationBar() {
        navigationItem.title = "AMARO"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-shopping")) { _ in
            CartListViewController().open(flow: .modal(createNavigation: true))
        }
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        updateCartQuantity()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: viewModel.filterNavigationImage) { _ in
            self.viewModel.changeFilter()
            self.updateFilterImage()
            self.collectionView.reloadData()
        }
    }
    
    private func updateCartQuantity() {
        let image = #imageLiteral(resourceName: "icon-shopping").withRenderingMode(.alwaysOriginal)
        var newImage = image
        let numberOfItems = CartManager.shared.numberOfItems
        if numberOfItems > 0 {
            newImage = textToImage(drawText: String(numberOfItems), inImage: image, atPoint: CGPoint(x: image.size.width / 2 - 4, y: image.size.height / 2 - 4))
        }
        self.navigationItem.rightBarButtonItem?.image = newImage
    }
    
    private func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.black]
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func updateFilterImage() {
        self.navigationItem.leftBarButtonItem?.image = viewModel.filterNavigationImage
    }
    
    private func setupCollectionView() {
        collectionView.register(ProductCollectionViewCell.self)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        viewState = .pullToRefresh
        getProducts()
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
    
    override var viewState: BaseViewController.ControllerState {
        didSet {
            switch viewState {
            case .loading:
                showActivityIndicator()
                collectionView.restore()
            case .pullToRefresh:
                showActivityIndicator()
            case .error:
                removeActivityIndicator()
                refreshControl.endRefreshing()
                showAlert(message: "Erro ao buscar os produtos")
                collectionView.setEmptyView(title: "Sem internet", message: "Não é possível encontrar produtos novos sem internet.")
            case .empty:
                collectionView.setEmptyView(title: "Ops!", message: "Parece que não temos mais produtos disponíveis.")
            case .default:
                removeActivityIndicator()
                refreshControl.endRefreshing()
                collectionView.restore()
            }
        }
    }
    
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.numberOfProducts() == 0 && viewState != .loading {
            viewState = .empty
        }
        return viewModel.numberOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(viewModel: viewModel.product(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProductDetailViewController(viewModel: viewModel.product(at: indexPath.row))
        controller.addedToCart = {
            self.updateCartQuantity()
        }
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true)
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2 - 10
        return CGSize(width: width, height: width * 1.7)
    }
}
