//
//  ShoppingItemTableViewCell.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/05.
//

import UIKit

class ShoppingItemTableViewCell: UITableViewCell {
    
    static let identifier = "ItemCell"

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemManufactureLabel: UILabel!
    @IBOutlet weak var itemAppendButton: UIButton!
    
}
