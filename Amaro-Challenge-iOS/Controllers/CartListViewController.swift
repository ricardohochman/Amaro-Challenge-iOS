//
//  CartListViewController.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class CartListViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    // MARK: - Constants
    let cartManager = CartManager.shared
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setups
    private func setupLayout() {
        self.totalPriceLabel.text = cartManager.totalPrice
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Carrinho"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-close")) { _ in
            self.close()
        }
    }
    
    private func setupTableView() {
        tableView.register(ProductCartTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100
    }
    
    // MARK: - Actions
    @IBAction func purchase() {
        if cartManager.numberOfProducts() == 0 {
            self.showAlert(title: "Ops!", message: "Você precisa ter ao menos um produto no carrinho para finalizar a compra.")
            return
        }
        
        cartManager.clearAll()
        showAlert(title: "Parabéns!", message: "Compra efetuada com sucesso") { _ in
            self.close()
        }
    }
}

extension CartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartManager.numberOfProducts() == 0 {
            tableView.setEmptyView(title: "Carrinho vazio", message: "Adicione um produto ao carrinho para aparecer aqui")
        } else {
            tableView.restore()
        }
        return cartManager.numberOfProducts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductCartTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setup(viewModel: cartManager.product(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            cartManager.removeFromCart(cartManager.product(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            setupLayout()
        }
    }
}
