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

protocol NewOrderIncomeDelegate: AnyObject {
    func addIncome(_ income: Income, oldName: String?)
    func removeIncome(forClientName clientName: String)

}

class NewOrderViewController: UIViewController {
    
    weak var incomeDelegate: NewOrderIncomeDelegate?
    
    weak var delegate: NewOrderDelegate?
    var orderNumber: Int?
    
    

    
    lazy var usernameField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        return tf
    }()

    lazy var amountField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.placeholder = "00.00"
        tf.keyboardType = .numberPad
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        return tf
    }()
    
    lazy var phoneField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Phone Number"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        tf.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
        }
        
        tf.textColor = .label
            tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "",
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
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
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
        
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var clientNameLabel: UILabel = makeLabel(withText: "Client name:")
    lazy var totalPrice: UILabel = makeLabel(withText: "Total price:")
    lazy var clientDescriptionLabel: UILabel = makeLabel(withText: "Description:")
    lazy var orderNumberLabel: UILabel = makeLabel(withText: "ORDER NUMBER \(orderNumber ?? 0)")
    lazy var phoneLabel: UILabel = makeLabel(withText: "Phone:")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "New Order"

        // Назначаем делегат для descriptionTextView
        descriptionTextView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        setupUI()
    }
    
    func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(orderNumberLabel)
        
        contentView.addSubview(clientNameLabel)
        contentView.addSubview(usernameField)
        
        contentView.addSubview(totalPrice)
        contentView.addSubview(amountField)
        
        contentView.addSubview(phoneField)
        contentView.addSubview(phoneLabel)
        
        contentView.addSubview(orderDatePickerLabel)
        contentView.addSubview(orderDatePicker)
        
        contentView.addSubview(deadlineDatePickerLabel)
        contentView.addSubview(deadlineDatePicker)
        
        contentView.addSubview(paidLabel)
        contentView.addSubview(paidSwitch)
        
        contentView.addSubview(clientDescriptionLabel)
        contentView.addSubview(descriptionTextView)
        
        contentView.addSubview(saveButton)
        

        
        NSLayoutConstraint.activate([
            
            
            
            orderNumberLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 25),
            orderNumberLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            clientNameLabel.topAnchor.constraint(equalTo: orderNumberLabel.topAnchor, constant: 35),
            clientNameLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            usernameField.topAnchor.constraint(equalTo: clientNameLabel.bottomAnchor, constant: 5),
            usernameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            totalPrice.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15),
            totalPrice.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            amountField.topAnchor.constraint(equalTo: totalPrice.bottomAnchor, constant: 5),
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

            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            
        ])
        
        contentView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30).isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardFrame.height + 20
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height + 20

            if descriptionTextView.isFirstResponder {
                let rect = descriptionTextView.convert(descriptionTextView.bounds, to: scrollView)
                scrollView.scrollRectToVisible(rect, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
            let alert = UIAlertController(title: "Oops 😬", message: "Fill all required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: orderDatePicker.date)
        let monthName = calendar.monthSymbols[(components.month ?? 1) - 1]
        let year = components.year ?? 2025
        _ = "\(monthName) \(year)"

        let newOrder = Order(
            id: UUID(),
            clientName: username,
            totalPrice: String(amount),
            orderDate: orderDatePicker.date,
            deadline: deadlineDatePicker.date,
            isPaid: paidSwitch.isOn,
            description: descriptionTextView.text,
            phoneNumber: phoneField.text ?? ""
        )

        if let priceString = newOrder.totalPrice, let totalPrice = Double(priceString) {
            let income = Income(clientName: newOrder.clientName, totalPrice: totalPrice)
            incomeDelegate?.addIncome(income, oldName: nil)
        }

        delegate?.addOrder(newOrder)
        
        NotificationCenter.default.post(name: .newOrderAdded, object: nil, userInfo: ["order": newOrder])

        navigationController?.popViewController(animated:true)
    }
}

extension NewOrderViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            let rect = textView.convert(textView.bounds, to: self.scrollView)
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
}
