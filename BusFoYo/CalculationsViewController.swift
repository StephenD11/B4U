//
//  CalculationsViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//


import UIKit

struct Income: Codable {
    var clientName: String
    var totalPrice: Double
}

struct Expense: Codable {
    var name: String
    var amount: Double
}

class IncomeExpenseCell: UITableViewCell {
    let nameLabel = UILabel()
    let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .right

        contentView.addSubview(nameLabel)
        contentView.addSubview(amountLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.widthAnchor.constraint(equalToConstant: 100),

            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8)
        ])

        nameLabel.font = UIFont.systemFont(ofSize: 13)
        amountLabel.font = UIFont.systemFont(ofSize: 13)
        layer.cornerRadius = 12
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalculationsViewController: UIViewController, NewOrderIncomeDelegate {
    
    
    var incomes: [Income] = []
    var expenses: [Expense] = []
    
    lazy var totalIncomeLabel: UILabel = makeLabel(text: "Total Income: 0")
    lazy var totalExpenseLabel: UILabel = makeLabel(text: "Total Expenses: 0")
    lazy var totalLabel: UILabel = makeLabel(text: "TOTAL: 0", fontSize: 18, textColor: .black)
    
    lazy var incomeTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(IncomeExpenseCell.self, forCellReuseIdentifier: "IncomeExpenseCell")
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .singleLine
        tv.separatorColor = .lightGray
        return tv
    }()

    lazy var expenseTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(IncomeExpenseCell.self, forCellReuseIdentifier: "IncomeExpenseCell")
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
        
        loadExpenses()
        loadIncomes()
        setupUI()
        updateTotals()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewOrder(_:)), name: .newOrderAdded, object: nil)
        
        
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
            incomeTableView.heightAnchor.constraint(equalToConstant: 250),

            
            totalIncomeLabel.topAnchor.constraint(equalTo: incomeTableView.bottomAnchor, constant: 5),
            totalIncomeLabel.leadingAnchor.constraint(equalTo: incomeTableView.leadingAnchor),
            
            expenseTableView.topAnchor.constraint(equalTo: totalIncomeLabel.bottomAnchor, constant: 20),
            expenseTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expenseTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expenseTableView.heightAnchor.constraint(equalToConstant: 250),
            
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
            self.saveExpenses()
            self.expenseTableView.reloadData()
            self.updateTotals()
        }))
        present(alert, animated: true)
    }
    
    func saveExpenses() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(expenses) {
            let username = UserManager.shared.currentUser?.username ?? "defaultUser"
            let key = "savedExpenses_\(username)"
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadExpenses() {
        let username = UserManager.shared.currentUser?.username ?? "defaultUser"
        let key = "savedExpenses_\(username)"
        if let savedData = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Expense].self, from: savedData) {
                expenses = decoded
            }
        }
    }

    func saveIncomes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(incomes) {
            let username = UserManager.shared.currentUser?.username ?? "defaultUser"
            let key = "savedIncomes_\(username)"
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func loadIncomes() {
        let username = UserManager.shared.currentUser?.username ?? "defaultUser"
        let key = "savedIncomes_\(username)"
        if let savedData = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Income].self, from: savedData) {
                incomes = decoded
            }
        }
    }
    
    @objc func handleNewOrder(_ notification: Notification) {
        guard let order = notification.userInfo?["order"] as? Order,
              let priceString = order.totalPrice,
              let price = Double(priceString) else { return }
        
        let income = Income(clientName: order.clientName, totalPrice: price)
        addIncome(income)
    }
    
    func addIncome(_ income: Income) {
        if let index = incomes.firstIndex(where: { $0.clientName == income.clientName }) {
            incomes[index] = income
        } else {
            incomes.append(income)   
        }
        saveIncomes()
        incomeTableView.reloadData()
        updateTotals()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseCell", for: indexPath) as! IncomeExpenseCell
            if indexPath.row == 0 {
                cell.nameLabel.text = "INCOME"
                cell.amountLabel.text = ""
                let bgView = UIView()
                bgView.backgroundColor = .systemGreen
                cell.backgroundView = bgView
                cell.nameLabel.textColor = .white
                cell.amountLabel.textColor = .white
                cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
                cell.selectionStyle = .none
            } else {
                let income = incomes[indexPath.row - 1]
                cell.nameLabel.text = "📍 \(income.clientName)"
                cell.amountLabel.text = String(format: "%.2f", income.totalPrice)
                cell.nameLabel.textColor = .black
                cell.amountLabel.textColor = .black
                cell.backgroundColor = .clear
                cell.backgroundView = nil
                cell.nameLabel.font = UIFont.systemFont(ofSize: 13)
                cell.amountLabel.font = UIFont.systemFont(ofSize: 13)
                cell.selectionStyle = .default
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseCell", for: indexPath) as! IncomeExpenseCell
            if indexPath.row == 0 {
                cell.nameLabel.text = "EXPENSES"
                cell.amountLabel.text = ""
                let bgView = UIView()
                bgView.backgroundColor = .systemRed
                cell.backgroundView = bgView
                cell.nameLabel.textColor = .white
                cell.amountLabel.textColor = .white
                cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
                cell.selectionStyle = .none
            } else {
                let expense = expenses[indexPath.row - 1]
                cell.nameLabel.text = "📍 \(expense.name)"
                cell.amountLabel.text = String(format: "%.2f", expense.amount)
                cell.nameLabel.textColor = .black
                cell.amountLabel.textColor = .black
                cell.backgroundColor = .clear
                cell.backgroundView = nil
                cell.nameLabel.font = UIFont.systemFont(ofSize: 13)
                cell.amountLabel.font = UIFont.systemFont(ofSize: 13)
                cell.selectionStyle = .default
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row != 0 else { return }
            
            if tableView == expenseTableView {
                expenses.remove(at: indexPath.row - 1)
                saveExpenses()
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateTotals()
            } else if tableView == incomeTableView {
                incomes.remove(at: indexPath.row - 1)
                saveIncomes()
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateTotals()
            }
            
        }
    }
    

}
