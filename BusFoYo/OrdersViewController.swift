//
//  OrdersViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//


import UIKit

class OrdersViewController: UIViewController {
    
    lazy var ordersLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Orders Screen"
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Orders"
        
        setupUI()
        
    }
    
    
    func setupUI() {
        
        view.addSubview(ordersLabel)
        
        
        NSLayoutConstraint.activate ([
            ordersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ordersLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
