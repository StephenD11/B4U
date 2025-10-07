//
//  CalculationsViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//


import UIKit

struct Income {
    var clientName: String
    var totalPrice: Double
}

struct Expense {
    var name: String
    var amount: Double
}

class CalculationsViewController: UIViewController {
    
    var incomes: [Income] = []
    var expenses: [Expense] = []
    
    lazy var totalIncomeLabel: UILabel = makeLabel(text: "Total Income: 0")
    lazy var totalExpenseLabel: UILabel = makeLabel(text: "Total Expenses: 0")
    lazy var totalLabel: UILabel = makeLabel(text: "TOTAL: 0", fontSize: 18, textColor: .blue)
    
    lazy var incomeTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "IncomeCell")
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .singleLine
        tv.separatorColor = .lightGray
        return tv
    }()

    lazy var expenseTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .singleLine
        tv.separatorColor = .lightGray
        return tv
    }()
    
    func makeLabel(text: String, fontSize: CGFloat = 14, textColor: UIColor = .black) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = text
        lbl.font = UIFont.boldSystemFont(ofSize: fontSize)
        lbl.textColor = textColor
        return lbl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Calculations"
        
        setupUI()
        updateTotals()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpense))
    }
    
    
    func setupUI() {
        view.addSubview(incomeTableView)
        view.addSubview(expenseTableView)
        view.addSubview(totalIncomeLabel)
        view.addSubview(totalExpenseLabel)
        view.addSubview(totalLabel)

        NSLayoutConstraint.activate([
            incomeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            incomeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            incomeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            incomeTableView.heightAnchor.constraint(equalToConstant: 200),
            
            totalIncomeLabel.topAnchor.constraint(equalTo: incomeTableView.bottomAnchor, constant: 5),
            totalIncomeLabel.leadingAnchor.constraint(equalTo: incomeTableView.leadingAnchor),
            
            expenseTableView.topAnchor.constraint(equalTo: totalIncomeLabel.bottomAnchor, constant: 20),
            expenseTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expenseTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expenseTableView.heightAnchor.constraint(equalToConstant: 200),
            
            totalExpenseLabel.topAnchor.constraint(equalTo: expenseTableView.bottomAnchor, constant: 5),
            totalExpenseLabel.leadingAnchor.constraint(equalTo: expenseTableView.leadingAnchor),
            
            totalLabel.topAnchor.constraint(equalTo: totalExpenseLabel.bottomAnchor, constant: 20),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    func updateTotals() {
        let incomeSum = incomes.reduce(0) { $0 + $1.totalPrice }
        let expenseSum = expenses.reduce(0) { $0 + $1.amount }
        totalIncomeLabel.text = "Total Income: \(String(format: "%.2f", incomeSum))"
        totalExpenseLabel.text = "Total Expenses: \(String(format: "%.2f", expenseSum))"
        totalLabel.text = "TOTAL: \(String(format: "%.2f", incomeSum - expenseSum))"
    }
    
    @objc func addExpense() {
        let alert = UIAlertController(title: "New Expense", message: "Enter name and amount", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Name" }
        alert.addTextField { tf in
            tf.placeholder = "Amount"
            tf.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let name = alert.textFields?[0].text ?? "Expense"
            let amount = Double(alert.textFields?[1].text ?? "0") ?? 0
            self.expenses.append(Expense(name: name, amount: amount))
            self.expenseTableView.reloadData()
            self.updateTotals()
        }))
        present(alert, animated: true)
    }
}

extension CalculationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == incomeTableView {
            return incomes.count + 1
        } else {
            return expenses.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == incomeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "INCOME"
                cell.backgroundColor = .systemGreen
                cell.textLabel?.textColor = .white
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                cell.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                cell.backgroundView = nil
            } else {
                let income = incomes[indexPath.row - 1]
                cell.textLabel?.text = "\(income.clientName): \(String(format: "%.2f", income.totalPrice))"
                cell.backgroundColor = .white
                cell.textLabel?.textColor = .black
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "EXPENSES"
                cell.backgroundColor = .systemRed
                cell.textLabel?.textColor = .white
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                cell.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                cell.backgroundView = nil
            } else {
                let expense = expenses[indexPath.row - 1]
                cell.textLabel?.text = "\(expense.name): \(String(format: "%.2f", expense.amount))"
                cell.backgroundColor = .white
                cell.textLabel?.textColor = .black
            }
            return cell
        }
    }
}
