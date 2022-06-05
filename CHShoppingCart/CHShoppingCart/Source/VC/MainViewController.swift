//
//  ViewController.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/04.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var ShoppingItemTableView: UITableView!
    
    var searchItemData: [ItemData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSet()
        searchBarSet()
    }
    
    func tableViewSet() {
        ShoppingItemTableView.delegate = self
        ShoppingItemTableView.dataSource = self
    }
    
    func searchBarSet() {
        let searchItem = UISearchController(searchResultsController: nil)
        searchItem.searchResultsUpdater = self
        searchItem.searchBar.delegate = self
        searchItem.searchBar.placeholder = "상품명을 검색하세요."
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchItem
    }
    
    @objc func appendItem(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            let newData = ItemData.ItemList[sender.tag]
            ItemData.AppendItem.append(newData)
            sender.backgroundColor = .lightGray
            sender.tintColor = .darkGray
            UIAlertController.showAlert(message: "장바구니에 담겼습니다. 더 쇼핑하시겠습니까?", viewController: self)
            print(ItemData.AppendItem)
        }
    }

    @IBAction func pushUIBarButton(_ sender: UIBarButtonItem) {
        guard let BasketVC = self.storyboard?.instantiateViewController(withIdentifier: "BasketVC") as? ShoppingBasketViewController else { return }
        self.navigationController?.pushViewController(BasketVC, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ShoppingItemTableViewCell else { return UITableViewCell() }
        let item = searchItemData[indexPath.row]
        cell.itemNameLabel.text = item.itemName
        cell.itemPriceLabel.text = "\(item.itemPrice)"
        cell.itemManufactureLabel.text = item.itemManufacture
        cell.itemAppendButton.addTarget(self, action: #selector(appendItem), for: .touchUpInside)
        cell.itemAppendButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItemData.count
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightForRowAt.height
    }
}

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchItem = searchController.searchBar.text {
            print(searchItem)
            searchItemData = ItemData.ItemList.filter{ $0.itemName.map { String ($0) }.contains(searchItem) }
            ShoppingItemTableView.reloadData()
            print(searchItemData)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ShoppingItemTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchItemData = []
        ShoppingItemTableView.reloadData()
    }
}
