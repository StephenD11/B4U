//
//  AuthView.swift
//  BusFoYo
//
//  Created by Stepan on 09.10.2025.
//

import UIKit


class AuthView: UIView {
    
    var stackViewBottomConstraint: NSLayoutConstraint?

    lazy var topDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Auth_top_detail")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "USERNAME"
        tf.borderStyle = .none
        tf.layer.cornerRadius = 6
        tf.layer.masksToBounds = true
        tf.autocapitalizationType = .none
        tf.returnKeyType = .next
        tf.font = UIFont(name: "IBMPlexMono-Regular", size: 13)
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        tf.textAlignment = .center
        tf.textColor = UIColor.black
        tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.gray]
        )
        return tf
    }()

    lazy var companyTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "COMPANY NAME"
        tf.borderStyle = .none
        tf.layer.cornerRadius = 6
        tf.layer.masksToBounds = true
        tf.autocapitalizationType = .words
        tf.returnKeyType = .next
        tf.font = UIFont(name: "IBMPlexMono-Regular", size: 13)
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        tf.textAlignment = .center
        tf.textColor = UIColor.black
        tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.gray]
        )
        return tf
    }()
    
    lazy var pinTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "PIN CODE"
        tf.borderStyle = .none
        tf.layer.cornerRadius = 6
        tf.layer.masksToBounds = true
        tf.isSecureTextEntry = true
        tf.keyboardType = .numberPad
        tf.font = UIFont(name: "IBMPlexMono-Regular", size: 13)

//        let infoButton = UIButton(type: .custom)
//        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
//        infoButton.frame = CGRect(x:0, y:0, width: 8, height: 8)
//
//        tf.rightView = infoButton
//        tf.rightViewMode = .always
        tf.returnKeyType = .done
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        tf.textAlignment = .center
        tf.textColor = UIColor.black
        tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.gray]
        )
        return tf
    }()

    lazy var enterButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "Button Enter Light"), for: .normal)
        btn.setImage(UIImage(named: "Button Enter dark"), for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
        
        pinTextField.keyboardType = .numberPad
        
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    


    private func setupUI() {
        addSubview(topDetailImageView)
        
        NSLayoutConstraint.activate([
            topDetailImageView.topAnchor.constraint(equalTo: topAnchor),
            topDetailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            topDetailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topDetailImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            companyTextField,
            pinTextField
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(enterButton)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            usernameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),

            companyTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            companyTextField.heightAnchor.constraint(equalToConstant: 40),

            pinTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            pinTextField.heightAnchor.constraint(equalToConstant: 40),

            enterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            enterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
            enterButton.heightAnchor.constraint(equalToConstant: 39.5)
        ])
        
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -50)
        stackViewBottomConstraint?.isActive = true
    }
    


}
