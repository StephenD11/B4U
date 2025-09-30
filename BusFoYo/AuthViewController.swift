//
//  AuthViewController.swift
//  BusFoYo
//
//  Created by Stepan on 27.09.2025.
//

import UIKit

class AuthViewController: UIViewController {

    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.returnKeyType = .next
        
        return tf
    }()

    lazy var companyTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Company Name"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.returnKeyType = .next
        return tf
    }()
    
    lazy var pinTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "PIN"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.keyboardType = .numberPad
        
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        infoButton.frame = CGRect(x:0, y:0, width: 8, height: 8)
        
        tf.rightView = infoButton
        tf.rightViewMode = .always
        tf.returnKeyType = .done
        return tf
    }()

    lazy var enterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Enter", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        pinTextField.keyboardType = .numberPad
        pinTextField.addTarget(self, action: #selector(limitPin), for: .editingChanged)
        
    }

    func setupUI() {
        view.addSubview(usernameTextField)
        view.addSubview(companyTextField)
        view.addSubview(pinTextField)
        view.addSubview(enterButton)

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),

            companyTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            companyTextField.centerXAnchor.constraint(equalTo: usernameTextField.centerXAnchor),
            companyTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            companyTextField.heightAnchor.constraint(equalToConstant: 44),
            
            pinTextField.topAnchor.constraint(equalTo: companyTextField.bottomAnchor, constant: 20),
            pinTextField.centerXAnchor.constraint(equalTo: usernameTextField.centerXAnchor),
            pinTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            pinTextField.heightAnchor.constraint(equalToConstant: 44),

            enterButton.topAnchor.constraint(equalTo: pinTextField.bottomAnchor, constant: 30),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func enterTapped() {
        view.endEditing(true)

        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !username.isEmpty,
              let company = companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !company.isEmpty else {
            let alert = UIAlertController(title: "Wrong", message: "Please fill all the fields 🚩", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        if UserManager.shared.currentUser == nil {
            guard let pin = pinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !pin.isEmpty else {
                let alert = UIAlertController(title: "Wrong", message: "Please enter a PIN 🚩", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                present(alert, animated: true)
                return
            }
            let newUser = User(username: username, company: company, pin: pin)
            UserManager.shared.saveUser(newUser)
        }

        let mainVC = MainViewController()
        navigationController?.setViewControllers([mainVC], animated: true)
    }
    
    @objc func showHint() {
        let alert = UIAlertController(title: "Notice", message: "PIN must contain 4 numbers 🙋‍♂️", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
        
    }   
    
    @objc func limitPin() {
        guard let text = pinTextField.text else { return }

        pinTextField.text = text.filter { "0123456789".contains($0) }

        if pinTextField.text!.count > 4 {
            pinTextField.text = String(pinTextField.text!.prefix(4))
        }
    }
}
