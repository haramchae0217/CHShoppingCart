//
//  ShoppingBasketViewController.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/05.
//

import UIKit

class ShoppingBasketViewController: UIViewController {

    enum CategoryType: String {
        case food = "식품"
        case life = "생활/건강"
        case beauty = "화장품/미용"
        case leisure = "여가/생활편의"
        case parenting = "출산/육아"
        case accessories = "패션잡화"
        case digital = "디지털/가전"
        case furniture = "가구/인테리어"
        case clothes = "패션의류"
        case sport = "스포츠/레저"
    }
    
    @IBOutlet weak var basketItemTableView: UITableView!
    @IBOutlet weak var emptyCartImageView: UIImageView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var leftMoneyLabel: UILabel!
    
    var category: [String] = []

    var foodItem: [Item] = []
    var lifeHealthItem: [Item] = []
    var beautyItem: [Item] = []
    var leisureLifeItem: [Item] = []
    var parentingItem: [Item] = []
    var accessoriesItem: [Item] = []
    var digitalItem: [Item] = []
    var furnitureItem: [Item] = []
    var clothesItem: [Item] = []
    var sportItem: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        tableViewSet()
        calcLeftMoney()
        basicImage()
        appendCategory()
        classificationOfCategory()
    }
    
    func classificationOfCategory() {
        for item in MyDB.appendItem {
            switch item.category1 {
            case CategoryType.food.rawValue: foodItem.append(item)
            case CategoryType.life.rawValue: lifeHealthItem.append(item)
            case CategoryType.beauty.rawValue: beautyItem.append(item)
            case CategoryType.leisure.rawValue: leisureLifeItem.append(item)
            case CategoryType.parenting.rawValue: parentingItem.append(item)
            case CategoryType.accessories.rawValue: accessoriesItem.append(item)
            case CategoryType.digital.rawValue: digitalItem.append(item)
            case CategoryType.furniture.rawValue: furnitureItem.append(item)
            case CategoryType.clothes.rawValue: clothesItem.append(item)
            case CategoryType.sport.rawValue: sportItem.append(item)
            default: print("예외사항 발생")
            }
        }
    }
    
    func appendCategory() {
        for str in MyDB.categoryList {
            category.append(str)
        }
    }
    
    func basicImage() {
        if MyDB.appendItem.isEmpty {
            emptyCartImageView.isHidden = false
        }
    }
    
    func configureNavigationController() {
        title = "장바구니"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "barItemColor")
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
        MyDB.appendItem.remove(at: sender.tag)
        calcLeftMoney()
        basicImage()
        basketItemTableView.reloadData()
    }
}

extension ShoppingBasketViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for i in 0...category.count-1 {
            switch category[i] {
            case CategoryType.food.rawValue: return foodItem.count
            case CategoryType.life.rawValue: return lifeHealthItem.count
            case CategoryType.beauty.rawValue: return beautyItem.count
            case CategoryType.leisure.rawValue: return leisureLifeItem.count
            case CategoryType.parenting.rawValue: return parentingItem.count
            case CategoryType.accessories.rawValue: return accessoriesItem.count
            case CategoryType.digital.rawValue: return digitalItem.count
            case CategoryType.furniture.rawValue: return furnitureItem.count
            case CategoryType.clothes.rawValue: return clothesItem.count
            case CategoryType.sport.rawValue: return sportItem.count
            default: return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemTableViewCell.identifer, for: indexPath) as? BasketItemTableViewCell else { return UITableViewCell() }
        var item: Item = Item(title: "", lprice: "", maker: "", category1: "")
        for i in 0...category.count-1 {
            if indexPath.section == i {
                switch category[i] {
                case CategoryType.food.rawValue:
                    item = foodItem[indexPath.row]
                case CategoryType.life.rawValue:
                    item = lifeHealthItem[indexPath.row]
                case CategoryType.beauty.rawValue:
                    item = beautyItem[indexPath.row]
                case CategoryType.leisure.rawValue:
                    item = leisureLifeItem[indexPath.row]
                case CategoryType.parenting.rawValue:
                    item = parentingItem[indexPath.row]
                case CategoryType.accessories.rawValue:
                    item = accessoriesItem[indexPath.row]
                case CategoryType.digital.rawValue:
                    item = digitalItem[indexPath.row]
                case CategoryType.furniture.rawValue:
                    item = furnitureItem[indexPath.row]
                case CategoryType.clothes.rawValue:
                    item = clothesItem[indexPath.row]
                case CategoryType.sport.rawValue:
                    item = sportItem[indexPath.row]
                default: print("")
                }
                cell.itemNameLabel.text = "상품명 : \(item.title.htmlEscaped)"
                cell.itemPriceLabel.text = "가격 : \(item.lprice)"
                cell.itemManufactureLabel.text = "제조사 : \(item.maker)"
                cell.itemRemoveButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
                cell.itemRemoveButton.tag = indexPath.row
            }
        }
    
        return cell
    }
}

extension ShoppingBasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightForRowAt.height
    }
}

/*
 print(category[i])
 switch category[i] {
 case CategoryType.food.rawValue:
     var item: Item = foodItem[indexPath.row]
 case CategoryType.life.rawValue:
     var item: Item = lifeHealthItem[indexPath.row]
 case CategoryType.beauty.rawValue:
     var item: Item = beautyItem[indexPath.row]
 case CategoryType.leisure.rawValue:
     var item: Item = leisureLifeItem[indexPath.row]
 case CategoryType.parenting.rawValue:
     var item: Item = parentingItem[indexPath.row]
 case CategoryType.accessories.rawValue:
     var item: Item = accessoriesItem[indexPath.row]
 case CategoryType.digital.rawValue:
     var item: Item = digitalItem[indexPath.row]
 case CategoryType.furniture.rawValue:
     var item: Item = furnitureItem[indexPath.row]
 case CategoryType.clothes.rawValue:
     var item: Item = clothesItem[indexPath.row]
 case CategoryType.sport.rawValue:
     var item: Item = sportItem[indexPath.row]
 default: print("")
 }
 cell.itemNameLabel.text = "상품명 : \(item.title.htmlEscaped)"
 cell.itemPriceLabel.text = "가격 : \(item.lprice)"
 cell.itemManufactureLabel.text = "제조사 : \(item.maker)"
 cell.itemRemoveButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
 cell.itemRemoveButton.tag = indexPath.row
 */
