//
//  CalculationsViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//


import UIKit



class CalculationsViewController: UIViewController, NewOrderIncomeDelegate {
    
    
    var incomes: [Income] = []
    var expenses: [Expense] = []
    
    
    lazy var totalIncomeLabel: UILabel = makeLabel(text: "Total Income: 0")
    lazy var totalExpenseLabel: UILabel = makeLabel(text: "Total Expenses: 0")
    lazy var totalLabel: UILabel = makeLabel(text: "TOTAL: 0", fontSize: 18, textColor: .black)
    
    lazy var incomeHeaderLabel: UILabel = makeLabel(text: "INCOME", fontSize: 14, textColor: .white)
    lazy var expenseHeaderLabel: UILabel = makeLabel(text: "EXPENSES", fontSize: 14, textColor: .white)
    
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
        lbl.textColor = .label
        return lbl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Calculations"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        loadExpenses()
        loadIncomes()
        setupUI()
        updateTotals()
        updateEmptyState()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewOrder(_:)), name: .newOrderAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderDeleted(_:)), name: .orderDeleted, object: nil)

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpense))
    }
    
    
    func setupUI() {
        view.addSubview(incomeHeaderLabel)
        view.addSubview(incomeTableView)
        view.addSubview(totalIncomeLabel)
        view.addSubview(expenseHeaderLabel)
        view.addSubview(expenseTableView)
        view.addSubview(totalExpenseLabel)
        view.addSubview(totalLabel)
        
        

        incomeHeaderLabel.backgroundColor = UIColor.systemGreen
        expenseHeaderLabel.backgroundColor = UIColor.systemRed
        incomeHeaderLabel.textColor = .white
        expenseHeaderLabel.textColor = .white
        incomeHeaderLabel.textAlignment = .center
        expenseHeaderLabel.textAlignment = .center
        
        incomeHeaderLabel.layer.cornerRadius = 8
        incomeHeaderLabel.clipsToBounds = true
        expenseHeaderLabel.layer.cornerRadius = 8
        expenseHeaderLabel.clipsToBounds = true

        NSLayoutConstraint.activate([
            incomeHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            incomeHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            incomeHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            incomeHeaderLabel.heightAnchor.constraint(equalToConstant: 25),

            incomeTableView.topAnchor.constraint(equalTo: incomeHeaderLabel.bottomAnchor, constant: 5),
            incomeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            incomeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            incomeTableView.heightAnchor.constraint(equalToConstant: 230),

            totalIncomeLabel.topAnchor.constraint(equalTo: incomeTableView.bottomAnchor, constant: 15),
            totalIncomeLabel.leadingAnchor.constraint(equalTo: incomeTableView.leadingAnchor),

            expenseHeaderLabel.topAnchor.constraint(equalTo: totalIncomeLabel.bottomAnchor, constant: 20),
            expenseHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expenseHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expenseHeaderLabel.heightAnchor.constraint(equalToConstant: 25),

            expenseTableView.topAnchor.constraint(equalTo: expenseHeaderLabel.bottomAnchor, constant: 5),
            expenseTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expenseTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expenseTableView.heightAnchor.constraint(equalToConstant: 230),

            totalExpenseLabel.topAnchor.constraint(equalTo: expenseTableView.bottomAnchor, constant: 15),
            totalExpenseLabel.leadingAnchor.constraint(equalTo: expenseTableView.leadingAnchor),

            totalLabel.topAnchor.constraint(equalTo: totalExpenseLabel.bottomAnchor, constant: 15),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleOrderDeleted(_ notification: Notification) {
        guard let clientName = notification.userInfo?["clientName"] as? String else { return }

        if let index = incomes.firstIndex(where: { $0.clientName == clientName }) {
            incomes.remove(at: index)
            saveIncomes()
            incomeTableView.reloadData()
            updateTotals()
            updateEmptyState()
        }
    }
    
    
    func updateTotals() {
        let incomeSum = incomes.reduce(0) { $0 + $1.totalPrice }
        let expenseSum = expenses.reduce(0) { $0 + $1.amount }
        totalIncomeLabel.text = "Total Income: \(String(format: "%.2f", incomeSum))"
        totalExpenseLabel.text = "Total Expenses: \(String(format: "%.2f", expenseSum))"
        totalLabel.text = "TOTAL: \(String(format: "%.2f", incomeSum - expenseSum))"
    }
    
    @objc func addExpense() {
        let alert = UIAlertController(title: "📌 New Expense 📌", message: "enter name and amount", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Expense" }
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
            self.updateEmptyState()
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
    
    func addIncome(_ income: Income, oldName: String? = nil) {
        if let oldName = oldName,
           let index = incomes.firstIndex(where: { $0.clientName == oldName }) {
            incomes[index] = income
        } else if let index = incomes.firstIndex(where: { $0.clientName == income.clientName }) {
            incomes[index] = income
        } else {
            incomes.append(income)
        }
        saveIncomes()
        incomeTableView.reloadData()
        updateTotals()
        updateEmptyState()
    }

    func removeIncome(forClientName clientName: String) {
        if let index = incomes.firstIndex(where: { $0.clientName == clientName }) {
            incomes.remove(at: index)
            saveIncomes()
            incomeTableView.reloadData()
            updateTotals()
            updateEmptyState()
        }
    }
    
    func updateEmptyState() {
        // Для таблицы доходов
        if incomes.isEmpty {
            let label = UILabel(frame: incomeTableView.bounds)
            label.text = "There are no records yet"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.font = UIFont.systemFont(ofSize: 14)
            incomeTableView.backgroundView = label
        } else {
            incomeTableView.backgroundView = nil
        }
        
        // Для таблицы расходов
        if expenses.isEmpty {
            let label = UILabel(frame: expenseTableView.bounds)
            label.text = "There are no records yet"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.font = UIFont.systemFont(ofSize: 14)
            expenseTableView.backgroundView = label
        } else {
            expenseTableView.backgroundView = nil
        }
    }
}

extension CalculationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == incomeTableView {
            return incomes.count
        } else {
            return expenses.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == incomeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseCell", for: indexPath) as! IncomeExpenseCell
            let income = incomes[indexPath.row]
            cell.nameLabel.text = "📍 \(income.clientName)"
            cell.amountLabel.text = String(format: "%.2f", income.totalPrice)
            cell.nameLabel.textColor = .label
            cell.amountLabel.textColor = .label
            cell.backgroundView = nil
            cell.nameLabel.font = UIFont.systemFont(ofSize: 13)
            cell.amountLabel.font = UIFont.systemFont(ofSize: 13)
            cell.selectionStyle = .default
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeExpenseCell", for: indexPath) as! IncomeExpenseCell
            let expense = expenses[indexPath.row]
            cell.nameLabel.text = "📍 \(expense.name)"
            cell.amountLabel.text = String(format: "%.2f", expense.amount)
            cell.nameLabel.textColor = .label
            cell.amountLabel.textColor = .label
            cell.backgroundView = nil
            cell.nameLabel.font = UIFont.systemFont(ofSize: 13)
            cell.amountLabel.font = UIFont.systemFont(ofSize: 13)
            cell.selectionStyle = .default
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == expenseTableView {
                expenses.remove(at: indexPath.row)
                saveExpenses()
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateTotals()
                updateEmptyState()
            } else if tableView == incomeTableView {
                incomes.remove(at: indexPath.row)
                saveIncomes()
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateTotals()
                updateEmptyState()
            }
            
        }
    }
    

}
