//
//  PinCodeViewController.swift
//  BusFoYo
//
//  Created by Stepan on 28.09.2025.
//

import UIKit
import RiveRuntime

class PinCodeViewController: UIViewController {
        
    lazy var backgroundAnimation: RiveViewModel = {
        return RiveViewModel(fileName: "pin_background_animation")
    }()
    
    lazy var pinLabelFieldText: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Enter PIN code"
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var pinTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "PIN"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        
        tf.isSecureTextEntry = true
        tf.textAlignment = .center
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        
        tf.textColor = .label
        tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "", attributes: [.foregroundColor: UIColor.secondaryLabel]
        )
        
        
        return tf
    }()
    
    
    lazy var forgotPinButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Forgot PIN code", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.addTarget(self, action: #selector(forgotPinTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var enterButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(named: "Button Go light"), for: .normal)
        btn.setImage(UIImage(named: "Button Go dark"), for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        pinTextField.keyboardType = .numberPad
        pinTextField.addTarget(self, action: #selector(limitPin), for: .editingChanged)
        
        enterButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        enterButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchDragExit])
        
        let riveView = backgroundAnimation.createRiveView()
        riveView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(riveView)
        view.sendSubviewToBack(riveView)
        
        NSLayoutConstraint.activate([
            riveView.topAnchor.constraint(equalTo: view.topAnchor),
            riveView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            riveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            riveView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.enterButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.enterButton.transform = .identity
        }
    }

    func setupUI() {
        view.addSubview(pinLabelFieldText)
        view.addSubview(pinTextField)
        view.addSubview(enterButton)
        view.addSubview(forgotPinButton)


        NSLayoutConstraint.activate([
            
            
            pinLabelFieldText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinLabelFieldText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            
            pinTextField.topAnchor.constraint(equalTo: pinLabelFieldText.bottomAnchor, constant: 10),
            pinTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinTextField.widthAnchor.constraint(equalToConstant: 150),
            pinTextField.heightAnchor.constraint(equalToConstant: 45),
            


            enterButton.topAnchor.constraint(equalTo: pinTextField.bottomAnchor, constant: 15),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.widthAnchor.constraint(equalToConstant: 180),
            enterButton.heightAnchor.constraint(equalToConstant: 35),

            
            forgotPinButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            forgotPinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func enterTapped() {
        view.endEditing(true)

        guard let enteredPin = pinTextField.text, !enteredPin.isEmpty else {
            showAlert(message: "the password is incorrect, please try again")
            return
        }

        guard let user = UserManager.shared.currentUser else {
            showAlert(message: "No user found")
            return
        }

        if enteredPin == user.pin {
            let mainVC = MainViewController()
            self.navigationController?.setViewControllers([mainVC], animated: true)

        } else {
            showAlert(message: "wrong PIN code, try again")
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops 😬 ", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func forgotPinTapped() {
        let alert = UIAlertController(title: "Password Recovery 🔐", message: "Enter your username to the field", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Username"
            textField.autocapitalizationType = .none
        }
        
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            guard let username = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !username.isEmpty else {
                self?.showAlert(message: "The field can't be empty")
                return
            }
            
            guard let user = UserManager.shared.currentUser, user.username.lowercased() == username.lowercased() || user.username == username else {
                self?.showAlert(message: "There is no such user in the database, try again")
                return
            }
            
            let pinAlert = UIAlertController(title: "Success ✅ ", message: "Your PIN: \(user.pin)", preferredStyle: .alert)
            pinAlert.addAction(UIAlertAction(title: "Great", style: .default))
            self?.present(pinAlert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete account", style: .destructive, handler: { _ in
            
            let mainAlert = UIAlertController(title: "🚨 WARNING 🚨 ", message: "All data will be deleted. Are you sure you want to delete your account? ", preferredStyle: .alert)
            
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
