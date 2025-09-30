//
//  MainViewController.swift
//  BusFoYo
//
//  Created by Stepan on 28.09.2025.
//
import UIKit

class MainViewController: UIViewController {
    
    lazy var mainLabel: UILabel = {
       let lab = UILabel()
        lab.text = "\(UserManager.shared.currentUser?.company ?? "")"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize:18, weight: .bold)
        lab.textAlignment = .center
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var profileButton: UIButton = createButton(title: "Profile")
    lazy var ordersButton: UIButton = createButton(title: "Orders")
    lazy var clientsButton: UIButton = createButton(title: "Clients")
    lazy var calculationsButton: UIButton = createButton(title: "Calculation")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Main"
        setupUI()
        
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        ordersButton.addTarget(self, action: #selector(ordersTapped), for: .touchUpInside)
        clientsButton.addTarget(self, action: #selector( clientsTapped), for: .touchUpInside)
        calculationsButton.addTarget(self, action: #selector(calculationsTapped), for: .touchUpInside)
        
        
        
        
    }
    
    func createButton(title:String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.contentHorizontalAlignment = .left
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        config.titleAlignment = .leading
        btn.configuration = config
        
        return btn
    }
    

    
    func setupUI() {
        
        let stack = UIStackView(arrangedSubviews: [profileButton, ordersButton, clientsButton, calculationsButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(mainLabel)
        view.addSubview(stack)
        
        NSLayoutConstraint.activate ([
            
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            mainLabel.heightAnchor.constraint(equalToConstant: 44),
            
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stack.heightAnchor.constraint(equalToConstant: 300) 
            
            
        ])
    }
    
    
    @objc func profileTapped() {
        let vs = ProfileViewController()
        navigationController?.pushViewController(vs, animated: true)
    }
    
    @objc func ordersTapped() {
        let vs =  OrdersViewController()
        navigationController?.pushViewController(vs, animated: true)
    }
    
    @objc func clientsTapped() {
        let vs = ClientsViewController()
        navigationController?.pushViewController(vs, animated: true)
    }
    
    @objc func calculationsTapped() {
        let vs = CalculationsViewController()
        navigationController?.pushViewController(vs, animated: true)
    }
    
}


