//
//  OrderDetailViewController..swift
//  BusFoYo
//
//  Created by Stepan on 07.10.2025.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    weak var delegate: NewOrderDelegate?
    weak var incomeDelegate: NewOrderIncomeDelegate?
    
    let backgroundImageView = UIImageView(image: UIImage(named: "Back_Lines"))
    
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
        tv.backgroundColor = .none
        
        return tv
    }()
    
    lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.setImage(UIImage(named: "Button Save changes light"), for: .normal)
        btn.setImage(UIImage(named: "Button Save changes dark"), for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .system)
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
    lazy var phoneLabel: UILabel = makeLabel(withText: "Phone:")

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
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
        
        view.backgroundColor = .systemBackground
        title = "ℹ️ \(order.clientName)"
        
        order.oldName = order.clientName

        saveButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        saveButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        deleteButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        
        descriptionTextView.delegate = self

        setupUI()
        populateFields()
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
        
        contentView.addSubview(orderTotalPriceLabel)
        contentView.addSubview(amountField)
        
        contentView.addSubview(orderDatePickerLabel)
        contentView.addSubview(orderDatePicker)
        
        contentView.addSubview(deadlineDatePickerLabel)
        contentView.addSubview(deadlineDatePicker)
        
        contentView.addSubview(paidLabel)
        contentView.addSubview(paidSwitch)
        
        contentView.addSubview(orderDescriptionLabel)
        contentView.addSubview(descriptionTextView)
        
        contentView.addSubview(phoneField)
        contentView.addSubview(phoneLabel)

        
        contentView.addSubview(saveButton)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            
            orderNumberLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 25),
            orderNumberLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            clientNameLabel.topAnchor.constraint(equalTo: orderNumberLabel.topAnchor, constant: 35),
            clientNameLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            usernameField.topAnchor.constraint(equalTo: clientNameLabel.bottomAnchor, constant: 5),
            usernameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            orderTotalPriceLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15),
            orderTotalPriceLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            amountField.topAnchor.constraint(equalTo: orderTotalPriceLabel.bottomAnchor, constant: 5),
            amountField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            amountField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            phoneLabel.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 15),
            phoneLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            
            phoneField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            phoneField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            phoneField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            phoneField.heightAnchor.constraint(equalToConstant: 40),
            
            phoneField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 10),
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
            
            orderDescriptionLabel.topAnchor.constraint(equalTo: paidLabel.bottomAnchor, constant: 15),
            orderDescriptionLabel.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            
            descriptionTextView.topAnchor.constraint(equalTo: orderDescriptionLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),

            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 25),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 400),
            saveButton.heightAnchor.constraint(equalToConstant: 30),

            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        
        contentView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30).isActive = true

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight + 20
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 20
        
        if descriptionTextView.isFirstResponder {
            let rect = descriptionTextView.convert(descriptionTextView.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
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
    
    func populateFields() {
        usernameField.text = order.clientName
        amountField.text = order.totalPrice
        orderDatePicker.date = order.orderDate
        deadlineDatePicker.date = order.deadline
        paidSwitch.isOn = order.isPaid
        descriptionTextView.text = order.description
        phoneField.text = order.phoneNumber
    }
    
    @objc func saveTapped() {
        guard let username = usernameField.text, !username.isEmpty, let amountText = amountField.text, !amountText.isEmpty else {
            let alert = UIAlertController(title: "Oops 😬", message: "Fill username and amount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
    }
        
        if order.clientName != username {
            order.oldName = order.clientName
        }
        
        let updatedOrder = Order(
            id: order.id,
            oldName: order.oldName,
            clientName: username,
            totalPrice: amountText,
            orderDate: orderDatePicker.date,
            deadline: deadlineDatePicker.date,
            isPaid: paidSwitch.isOn,
            description: descriptionTextView.text,
            phoneNumber: phoneField.text ?? ""
        )
        
        delegate?.addOrder(updatedOrder)
        
        if let priceDouble = Double(amountText) {
                let updatedIncome = Income(clientName: username, totalPrice: priceDouble)
            incomeDelegate?.addIncome(updatedIncome, oldName: order.oldName)
        }

        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteTapped() {
        let alert = UIAlertController(title: "Delete order 🤔",
                                      message: "Are you sure you want to delete \(order.clientName)? ",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.deleteOrder(at: self.indexInMonth, month: self.monthName)
            self.incomeDelegate?.removeIncome(forClientName: self.order.clientName)
            NotificationCenter.default.post(name: .orderDeleted, object: nil, userInfo: ["clientName": self.order.clientName])

            
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }

    
}

extension Notification.Name {
    static let orderDeleted = Notification.Name("orderDeleted")
}



extension OrderDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            let rect = textView.convert(textView.bounds, to: self.scrollView)
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
}
