//
//  AuthView.swift
//  BusFoYo
//
//  Created by Stepan on 09.10.2025.
//

import UIKit

class AuthView: UIView {
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.returnKeyType = .next
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        
        return tf
    }()

    lazy var companyTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Company Name"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.returnKeyType = .next
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        
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
        infoButton.frame = CGRect(x:0, y:0, width: 8, height: 8)
        
        tf.rightView = infoButton
        tf.rightViewMode = .always
        tf.returnKeyType = .done
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        
        
        return tf
    }()

    lazy var enterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Enter", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground 
        setupUI()
        
        pinTextField.keyboardType = .numberPad
        
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    
    private func setupUI() {
        addSubview(usernameTextField)
        addSubview(companyTextField)
        addSubview(pinTextField)
        addSubview(enterButton)

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
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
            enterButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
