//
//  PinCodeViewController.swift
//  BusFoYo
//
//  Created by Stepan on 28.09.2025.
//

import UIKit

class PinCodeViewController: UIViewController {

    lazy var pinTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter your PIN"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        
        tf.isSecureTextEntry = true
        tf.textAlignment = .center
        return tf
    }()
    
    
    lazy var forgotPinButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Forgot PIN", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.addTarget(self, action: #selector(forgotPinTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var enterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Enter", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
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
        view.addSubview(pinTextField)
        view.addSubview(enterButton)
        view.addSubview(forgotPinButton)


        NSLayoutConstraint.activate([
            pinTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            pinTextField.widthAnchor.constraint(equalToConstant: 150),
            pinTextField.heightAnchor.constraint(equalToConstant: 44),

            enterButton.topAnchor.constraint(equalTo: pinTextField.bottomAnchor, constant: 5),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            forgotPinButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            forgotPinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        

    }

    @objc func enterTapped() {
        view.endEditing(true)

        guard let enteredPin = pinTextField.text, !enteredPin.isEmpty else {
            showAlert(message: "You wrote wrong pin")
            return
        }

        guard let user = UserManager.shared.currentUser else {
            showAlert(message: "No user found")
            return
        }

        if enteredPin == user.pin {
            let mainVC = MainViewController()
            navigationController?.setViewControllers([mainVC], animated: true)
        } else {
            showAlert(message: "Please, try again")
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Wrong 🚫", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default))
        present(alert, animated: true)
    }
    
    @objc func forgotPinTapped() {
        let alert = UIAlertController(title: "Recover", message: "To restore the pin, you need to enter your account login 🫣", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Username"
            textField.autocapitalizationType = .none
        }
        
        alert.addAction(UIAlertAction(title: "Back", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak self] _ in
            guard let username = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !username.isEmpty else {
                self?.showAlert(message: "Please enter a username")
                return
            }
            
            guard let user = UserManager.shared.currentUser, user.username == username else {
                self?.showAlert(message: "No user found with this username")
                return
            }
            
            let pinAlert = UIAlertController(title: "Succes ✅ ", message: "Your pin is: \(user.pin)", preferredStyle: .alert)
            pinAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(pinAlert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Remove Account", style: .destructive, handler: { _ in
            
            let mainAlert = UIAlertController(title: "🚨 Warning 🚨 ", message: "All data will be deleted. Try to restore the PIN code. Are you sure you want to delete your account? ", preferredStyle: .alert)
            
            mainAlert.addAction(UIAlertAction(title: "No", style: .default))
            self.present(mainAlert, animated:true)
            
            mainAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                UserManager.shared.removeCurrentUser()
                let authVC = AuthViewController()
                self.navigationController?.setViewControllers([authVC], animated: true)
            }))

            
        }))
        
        self.present(alert, animated: true)
    }
    
    @objc func limitPin() {
        guard let text = pinTextField.text else { return }

        pinTextField.text = text.filter { "0123456789".contains($0) }

        if pinTextField.text!.count > 4 {
            pinTextField.text = String(pinTextField.text!.prefix(4))
        }
    }
    
    
}
