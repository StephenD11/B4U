//
//  Extensions.swift
//  BusFoYo
//
//  Created by Stepan on 08.10.2025.
//

import Foundation
import UIKit

extension Notification.Name {
    static let newOrderAdded = Notification.Name("newOrderAdded")
}

extension UIViewController {
    func applyAppBackgroundColor() {
        view.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
    }
}
