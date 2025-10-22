//
//  ProfileViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    let backgroundImageView = UIImageView(image: UIImage(named: "Back_Lines"))

    lazy var logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "business-card-svgrepo-com"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var usernameStack: UIStackView = {
        let label = UILabel()
        label.text = "Username:"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .center

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
        label.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [label, companyField])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    lazy var pinStack: UIStackView = {
        let label = UILabel()
        label.text = "PIN code"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [label, pinField])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    lazy var usernameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        tf.placeholder = "Username"
        tf.autocapitalizationType = .none
        tf.text = UserManager.shared.currentUser?.username
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        tf.textAlignment = .center
        tf.delegate = self
        return tf
    }()
    
    
    lazy var companyField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        tf.placeholder = "Company"
        tf.autocapitalizationType = .none
        tf.text = UserManager.shared.currentUser?.company
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        tf.textAlignment = .center
        tf.delegate = self
        return tf
    }()
    
    
    lazy var pinField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        tf.placeholder = "PIN"
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.text = UserManager.shared.currentUser?.pin
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        tf.textAlignment = .center
        tf.delegate = self
        return tf
    }()

    
    
    lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(named: "Button Save light"), for: .normal)
        btn.setImage(UIImage(named: "Button Save dark"), for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete Account", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        pinField.keyboardType = .numberPad
        pinField.addTarget(self, action: #selector(limitPin), for: .editingChanged)
        
        saveButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        saveButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        deleteButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height

        if self.view.frame.origin.y == 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y -= keyboardHeight / 3 // поднимаем немного, не на всю высоту
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    
    func setupUI() {
        
        view.addSubview(logoImageView)
        
        let stack = UIStackView(arrangedSubviews: [
            usernameStack,
            companyStack,
            pinStack,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 170),
            
            stack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            saveButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 25),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant:  35),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func saveTapped() {
        view.endEditing(true)
        
        guard let username = usernameField.text?.trimmingCharacters(in: .whitespaces),
              !username.isEmpty,
              let company = companyField.text?.trimmingCharacters(in: .whitespaces),
              !company.isEmpty,
              let pin = pinField.text?.trimmingCharacters(in: .whitespaces),
              !pin.isEmpty else {
            let alert = UIAlertController(title: "Oops 😬", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        if let currentUser = UserManager.shared.currentUser,
           username == currentUser.username &&
           company == currentUser.company &&
           pin == currentUser.pin {
            
            let alert = UIAlertController(title: "Notice", message: "No change detected 😶‍🌫️", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default))
            present(alert, animated: true)
            return
        }
        
        let oldUsername = UserManager.shared.currentUser?.username
        
        let updateUser = User(username: username, company: company, pin: pin)
        UserManager.shared.saveUser(updateUser)
        
        if let oldUsername = oldUsername, oldUsername != username {
            let oldKey = "allOrders_\(oldUsername)"
            let newKey = "allOrders_\(username)"
            
            if let oldData = UserDefaults.standard.data(forKey: oldKey) {
                UserDefaults.standard.set(oldData, forKey: newKey)
                UserDefaults.standard.removeObject(forKey: oldKey)
                print("✅ Orders moved from \(oldKey) → \(newKey)")
            } else {
                print("⚠️ No data found for \(oldKey)")
            }

            let oldExpensesKey = "savedExpenses_\(oldUsername)"
            let newExpensesKey = "savedExpenses_\(username)"
            if let oldExpensesData = UserDefaults.standard.data(forKey: oldExpensesKey) {
                UserDefaults.standard.set(oldExpensesData, forKey: newExpensesKey)
                UserDefaults.standard.removeObject(forKey: oldExpensesKey)
                print("✅ Expenses moved from \(oldExpensesKey) → \(newExpensesKey)")
            }

            let oldIncomesKey = "savedIncomes_\(oldUsername)"
            let newIncomesKey = "savedIncomes_\(username)"
            if let oldIncomesData = UserDefaults.standard.data(forKey: oldIncomesKey) {
                UserDefaults.standard.set(oldIncomesData, forKey: newIncomesKey)
                UserDefaults.standard.removeObject(forKey: oldIncomesKey)
                print("✅ Incomes moved from \(oldIncomesKey) → \(newIncomesKey)")
            }
        }
        
        let alert = UIAlertController(title: "Profile updated", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert,animated: true)
        
    }
    
    @objc func deleteTapped() {
        guard let currentUser = UserManager.shared.currentUser else { return }

        let alert = UIAlertController(title: "Delete Account", message: "Are you shure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            let ordersKey = "allOrders_\(currentUser.username)"
            UserDefaults.standard.removeObject(forKey: ordersKey)
            
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
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int
        if textField == pinField {
            maxLength = 4
        } else if textField == usernameField || textField == companyField {
            maxLength = 20
        } else {
            maxLength = Int.max
        }
        
        let currentString = textField.text ?? ""
        guard let stringRange = Range(range, in: currentString) else { return false }
        let updatedString = currentString.replacingCharacters(in: stringRange, with: string)
        
        return updatedString.count <= maxLength
    }
    
}
