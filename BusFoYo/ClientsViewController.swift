//
//  ClientsViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//

import UIKit

class ClientsViewController: UIViewController {
    
    lazy var clientsLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Clietns Screen"
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Clietns"
        
        setupUI()
        
    }
    
    
    func setupUI() {
        
        view.addSubview(clientsLabel)
        
        
        NSLayoutConstraint.activate ([
            clientsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clientsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
