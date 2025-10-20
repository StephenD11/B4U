//
//  NewOrderView.swift
//  BusFoYo
//
//  Created by Stepan on 07.10.2025.
//

import UIKit

class NewOrderView: UIView {
    
    lazy var usernameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var amountField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "00.00"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        return tf
    }()
    
    lazy var phoneField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Phone Number"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        return tf
    }()
    
    lazy var orderDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .date
        return dp
    }()
    
    lazy var deadlineDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .date
        return dp
    }()
    
    lazy var orderDatePickerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Order date:"
        return lbl
    }()
    
    lazy var deadlineDatePickerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Deadline:"
        return lbl
    }()
    
    lazy var paidSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    lazy var paidLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Payment Status:"
        return lbl
    }()
    
    lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1.0
        tv.layer.cornerRadius = 8
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save order", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    lazy var clientNameLabel: UILabel = makeLabel(withText: "Client name:")
    lazy var totalPriceLabel: UILabel = makeLabel(withText: "Total price:")
    lazy var clientDescriptionLabel: UILabel = makeLabel(withText: "Description:")
    lazy var orderNumberLabel: UILabel = makeLabel(withText: "ORDER NUMBER 0")
    lazy var phoneLabel: UILabel = makeLabel(withText: "Phone:")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setupUI() {
        addSubview(orderNumberLabel)
        addSubview(clientNameLabel)
        addSubview(usernameField)
        addSubview(totalPriceLabel)
        addSubview(amountField)
        addSubview(phoneLabel)
        addSubview(phoneField)
        addSubview(orderDatePickerLabel)
        addSubview(orderDatePicker)
        addSubview(deadlineDatePickerLabel)
        addSubview(deadlineDatePicker)
        addSubview(paidLabel)
        addSubview(paidSwitch)
        addSubview(clientDescriptionLabel)
        addSubview(descriptionTextView)
        addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            orderNumberLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
            orderNumberLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            clientNameLabel.topAnchor.constraint(equalTo: orderNumberLabel.topAnchor, constant: 35),
            clientNameLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            usernameField.topAnchor.constraint(equalTo: clientNameLabel.bottomAnchor, constant: 5),
            usernameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            totalPriceLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15),
            totalPriceLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            amountField.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 5),
            amountField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            amountField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            phoneLabel.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 15),
            phoneLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            phoneField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            phoneField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            phoneField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            phoneField.heightAnchor.constraint(equalToConstant: 40),
            
            orderDatePickerLabel.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 25),
            orderDatePickerLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            orderDatePicker.centerYAnchor.constraint(equalTo: orderDatePickerLabel.centerYAnchor),
            orderDatePicker.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
        
            deadlineDatePickerLabel.topAnchor.constraint(equalTo: orderDatePicker.bottomAnchor, constant: 25),
            deadlineDatePickerLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            deadlineDatePicker.centerYAnchor.constraint(equalTo: deadlineDatePickerLabel.centerYAnchor),
            deadlineDatePicker.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            paidLabel.topAnchor.constraint(equalTo: deadlineDatePicker.bottomAnchor, constant: 25),
            paidLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            paidSwitch.centerYAnchor.constraint(equalTo: paidLabel.centerYAnchor),
            paidSwitch.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            clientDescriptionLabel.topAnchor.constraint(equalTo: paidLabel.bottomAnchor, constant: 15),
            clientDescriptionLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            descriptionTextView.topAnchor.constraint(equalTo: clientDescriptionLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func makeLabel(withText text: String, fontSize: CGFloat = 14, textColor: UIColor = .gray) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = text
        lbl.font = UIFont.systemFont(ofSize: fontSize)
        lbl.textColor = textColor
        return lbl
    }
}
