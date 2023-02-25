//
//  ViewController.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/04.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var ShoppingItemTableView: UITableView!
    @IBOutlet weak var budgetSetView: UIView!
    @IBOutlet weak var inputBudgetTextField: UITextField!
    
    let searchItem = UISearchController(searchResultsController: nil)
    var alreadyAppendItemList: [Int] = []
    var searchItemData: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.ShoppingItemTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        tableViewSet()
        searchBarSet()
        budgetSetView.isHidden = true
    }
    
    func configureNavigationController() {
        title = "WookPang"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "barItemColor")
    }
    
    func tableViewSet() {
        ShoppingItemTableView.delegate = self
        ShoppingItemTableView.dataSource = self
    }
    
    func searchBarSet() {
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
                self.alreadyAppendItem()
                let sortList = self.alreadyAppendItemList.sorted(by: { $0 > $1 })
                if !self.alreadyAppendItemList.isEmpty {
                    for index in sortList {
                        self.searchItemData.remove(at: index)
                    }
                }
            } else {
                print("검색 실패",code)
            }
        }
    }
    
    func alreadyAppendItem() {
        alreadyAppendItemList = []
        for item in MyDB.appendItem {
            var count: Int = 0
            for data in searchItemData {
                count += 1
                if item.title == data.title && item.lprice == data.lprice && item.maker == data.maker && item.category1 == data.category1 {
                    alreadyAppendItemList.append(count - 1)
                }
            }
        }
    }
    
    @objc func appendItem(_ sender: UIButton) {
        /*
         진행 상황
         버튼 회색 부분
         */
        
        let newData = searchItemData[sender.tag]
        let newCategory = searchItemData[sender.tag].category1
        MyDB.appendItem.append(newData)
        MyDB.categoryList.insert(newCategory)
        sender.backgroundColor = .lightGray
        sender.tintColor = .darkGray
        
        let alert = UIAlertController(title: "알림", message: "장바구니에 담겼습니다. 더 쇼핑하시겠습니까?" , preferredStyle: .alert)
        let shoppingMoreButton = UIAlertAction(title: "더 쇼핑하기", style: .cancel, handler: nil)
        let shoppingStopButton = UIAlertAction(title: "장바구니로 가기", style: .default) { _ in
            guard let BasketVC = self.storyboard?.instantiateViewController(withIdentifier: "BasketVC") as? ShoppingBasketViewController else { return }
            self.navigationController?.pushViewController(BasketVC, animated: true)
        }
        alert.addAction(shoppingMoreButton)
        alert.addAction(shoppingStopButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func inputBudgetButton(_ sender: UIButton) {
        let budget = inputBudgetTextField.text!
        if budget.isEmpty {
            MyDB.myBudget = 0
        } else {
            MyDB.myBudget = Int(budget)!
        }
        searchItem.searchBar.isHidden = false
        budgetSetView.isHidden = true
        ShoppingItemTableView.isHidden = false
    }
    
    @IBAction func setMyBudgetButton(_ sender: UIBarButtonItem) {
        searchItem.searchBar.isHidden = true
        ShoppingItemTableView.isHidden = true
        budgetSetView.isHidden = false
    }

    @IBAction func pushUIBarButton(_ sender: UIBarButtonItem) {
        guard let BasketVC = self.storyboard?.instantiateViewController(withIdentifier: "BasketVC") as? ShoppingBasketViewController else { return }
        self.navigationController?.pushViewController(BasketVC, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ShoppingItemTableViewCell else { return UITableViewCell() }
        if !searchItemData.isEmpty {
            let item = searchItemData[indexPath.row]
            cell.itemNameLabel.text = "상품명 : \(item.title.htmlEscaped)"
            cell.itemPriceLabel.text = "가격 : \(item.lprice)원"
            cell.itemManufactureLabel.text = "제조사 : \(item.maker)"
            cell.itemAppendButton.addTarget(self, action: #selector(appendItem), for: .touchUpInside)
            cell.itemAppendButton.tag = indexPath.row
        }
        
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

extension MainViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchItem = searchBar.text {
            apiService(query: searchItem)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchItemData = []
    }
}

extension String {
    // html 태그 제거 + html entity들 디코딩.
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}
