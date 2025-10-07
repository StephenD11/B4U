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
    
    lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileButton, ordersButton, calculationsButton] )
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    

    
    lazy var centerImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "default_main"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    func createBottomButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    lazy var profileNextButton = {
        let btn = UIButton()
        btn.setTitle("", for: . normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.layer.cornerRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var profileButton: UIButton = createBottomButton(title: "PROFILE")
    lazy var ordersButton: UIButton = createBottomButton(title: "ORDERS")
    lazy var calculationsButton: UIButton = createBottomButton(title: "CASH")
    
 
    
    let images = ["profileImage", "ordersImage", "calculationsImage"]
    var selectedButton: UIButton?
    var isAnimating = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        ordersButton.addTarget(self, action: #selector(ordersTapped), for: .touchUpInside)
        calculationsButton.addTarget(self, action: #selector(calculationsTapped), for: .touchUpInside)
        
        centerImageView.isUserInteractionEnabled = true
        
    }
    
    func setupUI() {
        
        view.addSubview(mainLabel)
        view.addSubview(centerImageView)
        view.addSubview(profileNextButton)
        view.addSubview(bottomStack)
        
        NSLayoutConstraint.activate ([
            
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            mainLabel.heightAnchor.constraint(equalToConstant: 44),
            
            centerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            centerImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            centerImageView.heightAnchor.constraint(equalTo: centerImageView.widthAnchor),
        

                    
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            bottomStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            bottomStack.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    @objc func profileTapped() {
        changeCenterImage(to: images[0], selected: profileButton)
    }
    
    @objc func ordersTapped() {
        changeCenterImage(to: images[1], selected: ordersButton)
    }
    
    @objc func calculationsTapped() {
        changeCenterImage(to: images[2], selected: calculationsButton)
    }
    
    func changeCenterImage(to imageName: String, selected button: UIButton) {
        guard selectedButton !== button else { return }
        guard !isAnimating else { return }
        isAnimating = true

        let oldImageView = self.centerImageView

        let oldButton = view.viewWithTag(999)

        let newImageView = UIImageView(image: UIImage(named: imageName))
        newImageView.contentMode = .scaleAspectFit
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newImageView)

        NSLayoutConstraint.activate([
            newImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            newImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            newImageView.heightAnchor.constraint(equalTo: newImageView.widthAnchor),
        ])

        let buttonTitle: String
        switch imageName {
        case "profileImage":
            buttonTitle = "ENTER TO PROFILE"
        case "ordersImage":
            buttonTitle = "SEE YOUR ORDERS"
        case "calculationsImage":
            buttonTitle = "CHECK YOUR CASH"
        default:
            buttonTitle = "ACTION"
        }
        
        
        let imageActionButton = UIButton(type: .system)
        
        imageActionButton.tag = 999
        imageActionButton.setTitle(buttonTitle, for: .normal)
        imageActionButton.setTitleColor(.white, for: .normal)
        imageActionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        imageActionButton.backgroundColor = UIColor(red: 1.0, green: 0.55, blue: 0.0, alpha: 1.0)
        imageActionButton.layer.cornerRadius = 6
        imageActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageActionButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        
        view.addSubview(imageActionButton)
        NSLayoutConstraint.activate([
            imageActionButton.topAnchor.constraint(equalTo: newImageView.bottomAnchor, constant: 15),
            imageActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageActionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            imageActionButton.heightAnchor.constraint(equalToConstant: 28),
        ])

        newImageView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        imageActionButton.transform = CGAffineTransform(translationX: view.frame.width, y: 0)

        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.4, animations: {
            oldImageView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            oldButton?.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            newImageView.transform = .identity
            imageActionButton.transform = .identity
        }, completion: { _ in
            oldImageView.removeFromSuperview()
            oldButton?.removeFromSuperview()
            self.centerImageView = newImageView
            self.isAnimating = false
        })

        self.selectedButton?.setTitleColor(.black, for: .normal)
        button.setTitleColor(.orange, for: .normal)

        UIView.animate(withDuration: 0.3) {
            self.selectedButton?.transform = .identity
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }

        selectedButton = button
    }

    @objc func imageButtonTapped(_ sender: UIButton) {
        if sender.title(for: .normal) == "ENTER TO PROFILE" {
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        }
        
        if sender.title(for: .normal) == "SEE YOUR ORDERS" {
            let ordersVC = OrdersViewController()
            navigationController?.pushViewController(ordersVC, animated: true)
        }
        
        if sender.title(for: .normal) == "CHECK YOUR CASH" {
            let calculationVC = CalculationsViewController()
            navigationController?.pushViewController(calculationVC, animated: true)
        }
        
        
    }
    
}
