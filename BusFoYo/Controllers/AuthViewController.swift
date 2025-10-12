//
//  AuthViewController.swift
//  BusFoYo
//
//  Created by Stepan on 27.09.2025.
//

import UIKit

class AuthViewController: UIViewController {

    private let authView = AuthView()
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        authView.enterButton.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)
        authView.pinTextField.addTarget(self, action: #selector(limitPin), for: .editingChanged)
        
        if let infoButton = authView.pinTextField.rightView as? UIButton {
                infoButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
            }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func enterTapped() {
        view.endEditing(true)

        guard let username = authView.usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !username.isEmpty,
              let company = authView.companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !company.isEmpty else {
            let alert = UIAlertController(title: "Something's wrong 😬", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Let me try again", style: .default))
            present(alert, animated: true)
            return
        }
        
        if UserManager.shared.currentUser == nil {
            guard let pin = authView.pinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !pin.isEmpty else {
                let alert = UIAlertController(title: "OOPS 😬", message: "You forgot to add a PIN code", preferredStyle: .alert)
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
        let alert = UIAlertController(title: "Notice 🔐", message: "PIN must contain 4 numbers", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Understood", style: .default))
        present(alert, animated: true)
        
    }   
    
    @objc func limitPin() {
        guard let text = authView.pinTextField.text else { return }

        authView.pinTextField.text = text.filter { "0123456789".contains($0) }

        if authView.pinTextField.text!.count > 4 {
            authView.pinTextField.text = String(authView.pinTextField.text!.prefix(4))
        }
    }
}
