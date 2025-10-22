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


extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let text = self.text, self.font.fontName != "IBMPlexMono-Light" {
            self.font = UIFont(name: "IBMPlexMono-Light", size: self.font.pointSize)
        }
    }
}

extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let titleLabel = self.titleLabel {
            titleLabel.font = UIFont(name: "IBMPlexMono-Light", size: titleLabel.font.pointSize)
        }
    }
}

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let text = self.text, let fontSize = self.font?.pointSize {
            self.font = UIFont(name: "IBMPlexMono-Light", size: fontSize)
        }
    }
}
