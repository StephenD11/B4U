//
//  ProfileViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var usernameStack: UIStackView = {
        let label = UILabel()
        label.text = "Login:"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)

        let stack = UIStackView(arrangedSubviews: [label, usernameField])
        stack.axis = .vertical
        stack.spacing = 4
        
        return stack
    }()

    lazy var companyStack: UIStackView = {
        let label = UILabel()
        label.text = "Company name:"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        let stack = UIStackView(arrangedSubviews: [label, companyField])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    lazy var pinStack: UIStackView = {
        let label = UILabel()
        label.text = "Your PIN:"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        let stack = UIStackView(arrangedSubviews: [label, pinField])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    lazy var usernameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.text = UserManager.shared.currentUser?.username
        return tf
    }()
    
    lazy var companyField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Company"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.text = UserManager.shared.currentUser?.company
        return tf
    }()
    
    lazy var pinField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "PIN"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        
        tf.autocapitalizationType = .none
        tf.text = UserManager.shared.currentUser?.pin
        return tf
    }()
    
    
    lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteButton: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize:17)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"
        
        setupUI()
        
        pinField.keyboardType = .numberPad
        pinField.addTarget(self, action: #selector(limitPin), for: .editingChanged)
    }
    
    
    func setupUI() {
        
        
        
        saveButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        saveButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
            
        deleteButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        
        
        let stack = UIStackView(arrangedSubviews: [
            usernameStack,
            companyStack,
            pinStack,
            saveButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        

    }
    
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        sender.alpha = 0.6 //
    }

    @objc func buttonTouchUp(_ sender: UIButton) {
        sender.alpha = 1.0 //
    }
    
    @objc func saveTapped() {
        view.endEditing(true)
        
        guard let username = usernameField.text?.trimmingCharacters(in: .whitespaces),
              !username.isEmpty,
              let company = companyField.text?.trimmingCharacters(in: .whitespaces),
              !company.isEmpty,
              let pin = pinField.text?.trimmingCharacters(in: .whitespaces),
              !pin.isEmpty else {
            let alert = UIAlertController(title: "Wrong", message: "Please fill all fields 😒", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        if let currentUser = UserManager.shared.currentUser,
           username == currentUser.username &&
           company == currentUser.company &&
           pin == currentUser.pin {
            
            let alert = UIAlertController(title: "Notice", message: "No change detected 🤷‍♂️", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        
        let updateUser = User(username: username, company: company, pin: pin)
        UserManager.shared.saveUser(updateUser)
        
        let alert = UIAlertController(title: "Succes", message: "Profile Updated", preferredStyle: .alert)
        
        let mainVC = MainViewController()
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.navigationController?.setViewControllers([mainVC], animated: true)
        }))
        present(alert,animated: true)
        
    }
    
    @objc func deleteTapped() {
        
        let alert = UIAlertController(title: "Delete Account", message: "Are you shure? 🤯", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            UserManager.shared.removeCurrentUser()
            
            let authVC = AuthViewController()
            self.navigationController?.setViewControllers([authVC], animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated:true)
        
    }
    
    @objc func limitPin() {
        guard let text = pinField.text else { return }
        pinField.text = text.filter { "0123456789".contains($0) }
        
        if pinField.text!.count > 4 {
            pinField.text = String(pinField.text!.prefix(4))
        }
    }
    
}
