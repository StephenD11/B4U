//
//  AuthView.swift
//  BusFoYo
//
//  Created by Stepan on 09.10.2025.
//

import UIKit

class AuthView: UIView {
    
    
    lazy var registrationLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "REGISTRATION"
        lb.textColor = .black
        lb.font = .boldSystemFont(ofSize: 22)
        return lb
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Your username"
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
        tf.placeholder = "Yout company name"
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
        let stackView = UIStackView(arrangedSubviews: [
            registrationLabel,
            usernameTextField,
            companyTextField,
            pinTextField,
            enterButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            usernameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),

            companyTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            companyTextField.heightAnchor.constraint(equalToConstant: 44),

            pinTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            pinTextField.heightAnchor.constraint(equalToConstant: 44),

            enterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
