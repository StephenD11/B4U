//
//  AuthViewController.swift
//  BusFoYo
//
//  Created by Stepan on 27.09.2025.
//

import UIKit

class AuthViewController: UIViewController {
    
    let backgroundImageView = UIImageView(image: UIImage(named: "Background_Auth"))
    
    private let authView = AuthView()
    private var authViewBottomConstraint: NSLayoutConstraint?
    
    override func loadView() {
        self.view = UIView()
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        authView.backgroundColor = .clear
        authView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authView)
        
        authViewBottomConstraint = authView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        authViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            authView.topAnchor.constraint(equalTo: view.topAnchor),
            authView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
        
        authView.enterButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        authView.enterButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchDragExit])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.authView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.authView.transform = .identity
        }
    }
    
    @objc func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.authView.enterButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.authView.enterButton.transform = .identity
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
