//
//  BasketItemTableViewCell.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/05.
//

import UIKit

class BasketItemTableViewCell: UITableViewCell {

    static let identifer = "BasketCell"
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemManufactureLabel: UILabel!
    @IBOutlet weak var itemRemoveButton: UIButton!
    
}
