//
//  OrderDetailViewController..swift
//  BusFoYo
//
//  Created by Stepan on 07.10.2025.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    weak var delegate: NewOrderDelegate?
    var order: Order
    var monthName: String!
    var indexInMonth: Int!
    var orderNumber: Int?

    
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var usernameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var amountFiled: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
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
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save changes", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete order", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var clientNameLabel: UILabel = makeLabel(withText: "Client name:")
    lazy var orderTotalPriceLabel: UILabel = makeLabel(withText: "Total price:")
    lazy var orderDescriptionLabel: UILabel = makeLabel(withText: "Description:")
    lazy var orderNumberLabel: UILabel = makeLabel(withText: "ORDER NUMBER \(orderNumber ?? 0)")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "ℹ️ \(order.clientName)"
        setupUI()
        populateFields()
    }
    
    
    func setupUI() {
        view.addSubview(orderNumberLabel)
        
        view.addSubview(clientNameLabel)
        view.addSubview(usernameField)
        
        view.addSubview(orderTotalPriceLabel)
        view.addSubview(amountFiled)
        
        view.addSubview(orderDatePickerLabel)
        view.addSubview(orderDatePicker)
        
        view.addSubview(deadlineDatePickerLabel)
        view.addSubview(deadlineDatePicker)
        
        view.addSubview(paidLabel)
        view.addSubview(paidSwitch)
        
        view.addSubview(orderDescriptionLabel)
        view.addSubview(descriptionTextView)
        
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            
            orderNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            orderNumberLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            clientNameLabel.topAnchor.constraint(equalTo: orderNumberLabel.topAnchor, constant: 35),
            clientNameLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            usernameField.topAnchor.constraint(equalTo: clientNameLabel.bottomAnchor, constant: 5),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            orderTotalPriceLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15),
            orderTotalPriceLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            amountFiled.topAnchor.constraint(equalTo: orderTotalPriceLabel.bottomAnchor, constant: 5),
            amountFiled.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            amountFiled.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            orderDatePickerLabel.topAnchor.constraint(equalTo: amountFiled.bottomAnchor, constant: 25),
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
            
            orderDescriptionLabel.topAnchor.constraint(equalTo: paidLabel.bottomAnchor, constant: 15),
            orderDescriptionLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            descriptionTextView.topAnchor.constraint(equalTo: orderDescriptionLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),

            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
    func populateFields() {
        usernameField.text = order.clientName
        amountFiled.text = order.totalPrice
        orderDatePicker.date = order.orderDate
        deadlineDatePicker.date = order.deadline
        paidSwitch.isOn = order.isPaid
        descriptionTextView.text = order.description
    }
    
    @objc func saveTapped() {
        guard let username = usernameField.text, !username.isEmpty, let amountText = amountFiled.text, !amountText.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please fill username and age", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
    }
        order.clientName = username
        order.totalPrice = amountText
        order.orderDate = orderDatePicker.date
        order.deadline = deadlineDatePicker.date
        order.isPaid = paidSwitch.isOn
        order.description = descriptionTextView.text
        
        delegate?.addOrder(order)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteTapped() {
        let alert = UIAlertController(title: "Delete order",
                                      message: "Are you sure you want to delete \(order.clientName)?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.deleteOrder(at: self.indexInMonth, month: self.monthName)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }

    
}
