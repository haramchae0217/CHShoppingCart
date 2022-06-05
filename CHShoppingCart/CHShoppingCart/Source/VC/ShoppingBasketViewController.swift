//
//  ShoppingBasketViewController.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/05.
//

import UIKit

class ShoppingBasketViewController: UIViewController {

    @IBOutlet weak var basketItemTableView: UITableView!
    @IBOutlet weak var emptyCartImageView: UIImageView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var leftMoneyLabel: UILabel!
    
    var itemType: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "장바구니"
        
        tableViewSet()
        calcLeftMoney()
        
        if !ItemData.AppendItem.isEmpty {
            emptyCartImageView.isHidden = true
        }
    }
    
    func tableViewSet() {
        basketItemTableView.delegate = self
        basketItemTableView.dataSource = self
    }
    
    func calcLeftMoney() {
        let myBudget = 10000
        var totalPrice: Int = 0
        var leftMoney: Int = 0
        
        for price in ItemData.AppendItem {
            totalPrice += price.itemPrice
        }
        
        for data in ItemData.ItemList {
            print(data)
            for check in ItemData.AppendItem {
                print(check)
                if check.itemType == data.itemType && check.itemName == data.itemName {
                    itemType.append(data.itemType)
                    print(data.itemType)
                }
            }
        }
        
        leftMoney = myBudget - totalPrice
        if leftMoney < 0 {
            leftMoneyLabel.textColor = .red
        } else {
            leftMoneyLabel.textColor = .blue
        }
        
        budgetLabel.text = "\(myBudget) 원"
        itemCountLabel.text = "\(ItemData.AppendItem.count) 개"
        totalPriceLabel.text = "\(totalPrice) 원"
        leftMoneyLabel.text = "\(leftMoney) 원"
    }
    
    @objc func removeItem(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            let removeData = ItemData.ItemList[sender.tag]
            ItemData.AppendItem.removeAll { data in
                data.itemName == removeData.itemName && data.itemPrice == removeData.itemPrice && data.itemManufacture == removeData.itemManufacture
            }
            basketItemTableView.reloadData()
            calcLeftMoney()
            print(ItemData.AppendItem)
        }
    }
}

extension ShoppingBasketViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemType.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return itemType[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemTableViewCell.identifer, for: indexPath) as? BasketItemTableViewCell else { return UITableViewCell() }
        let item = ItemData.AppendItem[indexPath.row]
        cell.itemNameLabel.text = "상품명 : \(item.itemName)"
        cell.itemPriceLabel.text = "가격 : \(item.itemPrice)"
        cell.itemManufactureLabel.text = "제조사 : \(item.itemManufacture)"
        cell.itemRemoveButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        cell.itemRemoveButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemData.AppendItem.count
    }
}

extension ShoppingBasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightForRowAt.height
    }
}
