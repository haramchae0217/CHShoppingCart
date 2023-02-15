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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "장바구니"
        
        tableViewSet()
        calcLeftMoney()
        basicImage()
    }
    
    func basicImage() {
        if !MyDB.appendItem.isEmpty {
            emptyCartImageView.isHidden = true
        }
    }
    
    func tableViewSet() {
        basketItemTableView.delegate = self
        basketItemTableView.dataSource = self
    }
    
    func calcLeftMoney() {
        let myBudget = MyDB.myBudget
        var totalPrice: Int = 0
        var leftMoney: Int = 0
        
        for price in MyDB.appendItem {
            totalPrice += Int(price.lprice)!
        }
        
        leftMoney = myBudget - totalPrice
        if leftMoney < 0 {
            leftMoneyLabel.textColor = .red
        } else {
            leftMoneyLabel.textColor = .blue
        }
        
        budgetLabel.text = "\(myBudget) 원"
        itemCountLabel.text = "\(MyDB.appendItem.count) 개"
        totalPriceLabel.text = "\(totalPrice) 원"
        leftMoneyLabel.text = "\(leftMoney) 원"
    }
    
    @objc func removeItem(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
//            let removeData = MainViewController.searchItemData[sender.tag]
//            MyDB.appendItem.removeAll { data in
//                 == removeData && data.itemPrice == removeData.itemPrice && data.itemManufacture == removeData.itemManufacture
//            }
            basicImage()
            basketItemTableView.reloadData()
            calcLeftMoney()
            print(MyDB.appendItem)
        }
    }
}

extension ShoppingBasketViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return itemType[section]
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemTableViewCell.identifer, for: indexPath) as? BasketItemTableViewCell else { return UITableViewCell() }
        let item = MyDB.appendItem[indexPath.row]
        cell.itemNameLabel.text = "상품명 : \(item.title)"
        cell.itemPriceLabel.text = "가격 : \(item.lprice)"
        cell.itemManufactureLabel.text = "제조사 : \(item.maker)"
        cell.itemRemoveButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        cell.itemRemoveButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDB.appendItem.count
    }
}

extension ShoppingBasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightForRowAt.height
    }
}
