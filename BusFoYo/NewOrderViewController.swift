//
//  NewOrderViewController.swift
//  BusFoYo
//
//  Created by Stepan on 30.09.2025.
//

import UIKit

protocol NewOrderDelegate: AnyObject {
    func addOrder(_ order: Order)
}

class NewOrderViewController: UIViewController {
    
    weak var delegate: NewOrderDelegate?
    
    lazy var usernameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        return tf
    }()

    lazy var ageField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Age"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
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
        lbl.text = "Paid"
        return lbl
    }()
    
    lazy var descriptionPlaceholder: UILabel = {
        let lbl = UILabel()
        lbl.text = "Enter description..."
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.borderColor = UIColor.lightGray.cgColor // рамка
        tv.layer.borderWidth = 1.0
        tv.layer.cornerRadius = 8
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Order"
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(usernameField)
        view.addSubview(ageField)
        view.addSubview(orderDatePickerLabel)
        view.addSubview(orderDatePicker)
        view.addSubview(deadlineDatePickerLabel)
        view.addSubview(deadlineDatePicker)
        view.addSubview(paidLabel)
        view.addSubview(paidSwitch)
        view.addSubview(descriptionTextView)
        descriptionTextView.addSubview(descriptionPlaceholder)

        
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            ageField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15),
            ageField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            ageField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            orderDatePickerLabel.topAnchor.constraint(equalTo: ageField.bottomAnchor, constant: 15),
            orderDatePickerLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            orderDatePicker.centerYAnchor.constraint(equalTo: orderDatePickerLabel.centerYAnchor),
            orderDatePicker.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
        
            deadlineDatePickerLabel.topAnchor.constraint(equalTo: orderDatePicker.bottomAnchor, constant: 15),
            deadlineDatePickerLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            deadlineDatePicker.centerYAnchor.constraint(equalTo: deadlineDatePickerLabel.centerYAnchor),
            deadlineDatePicker.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            paidLabel.topAnchor.constraint(equalTo: deadlineDatePicker.bottomAnchor, constant: 15),
            paidLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            paidSwitch.centerYAnchor.constraint(equalTo: paidLabel.centerYAnchor),
            paidSwitch.leadingAnchor.constraint(equalTo: paidLabel.trailingAnchor, constant: 10),
            
            descriptionTextView.topAnchor.constraint(equalTo: paidLabel.bottomAnchor, constant: 15),
            descriptionTextView.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),

            descriptionPlaceholder.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholder.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5)
        ])
    }
}
