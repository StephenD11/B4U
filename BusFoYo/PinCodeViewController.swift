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
        tf.placeholder = "Enter PIN"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.isSecureTextEntry = true
        tf.textAlignment = .center
        return tf
    }()

    // Кнопка Enter
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
    }

    func setupUI() {
        view.addSubview(pinTextField)
        view.addSubview(enterButton)

        NSLayoutConstraint.activate([
            pinTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            pinTextField.widthAnchor.constraint(equalToConstant: 150),
            pinTextField.heightAnchor.constraint(equalToConstant: 44),

            enterButton.topAnchor.constraint(equalTo: pinTextField.bottomAnchor, constant: 20),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func enterTapped() {
        view.endEditing(true)

        guard let enteredPin = pinTextField.text, !enteredPin.isEmpty else {
            showAlert(message: "Enter your PIN")
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
            showAlert(message: "Incorrect PIN, try again")
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
