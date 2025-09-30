//
//  CalculationsViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//

import UIKit

class CalculationsViewController: UIViewController {
    
    lazy var calculationsLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Calculations Screen"
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Calculations"
        
        setupUI()
        
    }
    
    
    func setupUI() {
        
        view.addSubview(calculationsLabel)
        
        
        NSLayoutConstraint.activate ([
            calculationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
