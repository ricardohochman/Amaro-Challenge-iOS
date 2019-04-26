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
        navigationItem.title = "Amaro"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-shopping")) { _ in
        }
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
