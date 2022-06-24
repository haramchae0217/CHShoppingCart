//
//  UIAlertController++Extension.swift
//  CHShoppingCart
//
//  Created by Chae_Haram on 2022/06/05.
//

import UIKit

extension UIAlertController {
    static func showAlert(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "알림", message: message , preferredStyle: .alert)
        let shoppingMoreButton = UIAlertAction(title: "더 쇼핑하기", style: .cancel)
        let shoppingStopButton = UIAlertAction(title: "장바구니로 가기", style: .default) { (action) in        
        }
        alert.addAction(shoppingMoreButton)
        alert.addAction(shoppingStopButton)
        viewController.present(alert, animated: true, completion: {})
    }
}
