//
//  ViewController.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/04.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var ShoppingItemTableView: UITableView!
    
    var searchItemData: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.ShoppingItemTableView.reloadData()
            }
        }
    }
    
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
    
    func apiService(query: String) {
        APIService().searchItem(query: query) { item, code in
            if code == 200 {
                guard let item = item else { return }
                self.searchItemData = item.items
            } else {
                print("검색 실패",code)
            }
        }
    }
    
    @objc func appendItem(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            let newData = searchItemData[sender.tag]
            MyDB.appendItem.append(newData)
            sender.backgroundColor = .lightGray
            sender.tintColor = .darkGray
            UIAlertController.showAlert(message: "장바구니에 담겼습니다. 더 쇼핑하시겠습니까?", viewController: self)
            print(MyDB.appendItem)
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
        cell.itemNameLabel.text = item.title
        cell.itemPriceLabel.text = "\(item.lprice)"
        cell.itemManufactureLabel.text = item.maker
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
            print("검색어 : ",searchItem)
//            searchItemData = ItemData.ItemList.filter{ $0.itemName.map { String ($0) }.contains(searchItem) }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let itemTitle = searchBar.text!
        apiService(query: itemTitle)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchItemData = []
    }
}
