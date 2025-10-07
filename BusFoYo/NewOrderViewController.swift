//
//  NewOrderViewController.swift
//  BusFoYo
//
//  Created by Stepan on 07.10.2025.
//

import UIKit

protocol NewOrderDelegate: AnyObject {
    func addOrder(_ order: Order)
    func deleteOrder(at index: Int, month: String)
}

class NewOrderViewController: UIViewController {
    

    
    weak var delegate: NewOrderDelegate?
    var orderNumber: Int?
    
    

    
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
        tf.placeholder = "Age"
        tf.borderStyle = .roundedRect
        tf.placeholder = "00.00"
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
        lbl.text = "Payment Status:"
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
    
    lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save order", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
        
    }()
    
    lazy var clientNameLabel: UILabel = makeLabel(withText: "Client name:")
    lazy var totalPrice: UILabel = makeLabel(withText: "Total price:")
    lazy var clientDescriptionLabel: UILabel = makeLabel(withText: "Description:")
    lazy var orderNumberLabel: UILabel = makeLabel(withText: "ORDER NUMBER \(orderNumber ?? 0)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Order"
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(orderNumberLabel)
        
        view.addSubview(clientNameLabel)
        view.addSubview(usernameField)
        
        view.addSubview(totalPrice)
        view.addSubview(amountField)
        
        view.addSubview(orderDatePickerLabel)
        view.addSubview(orderDatePicker)
        
        view.addSubview(deadlineDatePickerLabel)
        view.addSubview(deadlineDatePicker)
        
        view.addSubview(paidLabel)
        view.addSubview(paidSwitch)
        
        view.addSubview(clientDescriptionLabel)
        view.addSubview(descriptionTextView)
        
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            
            
            
            orderNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            orderNumberLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            clientNameLabel.topAnchor.constraint(equalTo: orderNumberLabel.topAnchor, constant: 35),
            clientNameLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            usernameField.topAnchor.constraint(equalTo: clientNameLabel.bottomAnchor, constant: 5),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            totalPrice.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15),
            totalPrice.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            amountField.topAnchor.constraint(equalTo: totalPrice.bottomAnchor, constant: 5),
            amountField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            amountField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            orderDatePickerLabel.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 25),
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
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
    
    @objc func saveTapped() {
        guard let username  = usernameField.text, !username.isEmpty,
              let amountText = amountField.text, let amount = Int(amountText),
              !amountText.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Fill all required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: orderDatePicker.date)
        let monthName = calendar.monthSymbols[(components.month ?? 1) - 1]
        let year = components.year ?? 2025
        let monthKey = "\(monthName) \(year)"

        let newOrder = Order(
            id: UUID(),
            clientName: username,
            totalPrice: String(amount),
            orderDate: orderDatePicker.date,
            deadline: deadlineDatePicker.date,
            isPaid: paidSwitch.isOn,
            description: descriptionTextView.text
        )
        

        delegate?.addOrder(newOrder)

        navigationController?.popViewController(animated:true)
    }
}
