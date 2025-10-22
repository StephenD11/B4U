//
//  CalculationsViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//


import UIKit
import RiveRuntime

class CalculationsViewController: UIViewController, NewOrderIncomeDelegate {
    
    
    var incomes: [Income] = []
    var expenses: [Expense] = []
    
    let backgroundImageView = UIImageView(image: UIImage(named: "Back_Lines"))
    
    
    lazy var totalIncomeLabel: UILabel = makeLabel(text: "Total Income: 0")
    lazy var totalExpenseLabel: UILabel = makeLabel(text: "Total Expenses: 0")
    lazy var totalLabel: UILabel = makeLabel(text: "TOTAL: 0", fontSize: 18, textColor: .black)
    
    let incomeHeaderAnimationViewModel = RiveViewModel(fileName: "income")
    lazy var incomeHeaderAnimationView: RiveView = {
        let riveView = incomeHeaderAnimationViewModel.createRiveView()
        riveView.translatesAutoresizingMaskIntoConstraints = false
        riveView.contentMode = .scaleAspectFit
        return riveView
    }()
    
    let expensesHeaderAnimationViewModel = RiveViewModel(fileName: "expenses")
    lazy var expensesHeaderAnimationView: RiveView = {
        let riveView = expensesHeaderAnimationViewModel.createRiveView()
        riveView.translatesAutoresizingMaskIntoConstraints = false
        riveView.contentMode = .scaleAspectFit
        return riveView
    }()

    
    lazy var incomeTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(IncomeExpenseCell.self, forCellReuseIdentifier: "IncomeExpenseCell")
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .singleLine
        tv.separatorColor = .lightGray
        tv.backgroundColor = .none
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
        tv.backgroundColor = .none
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
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
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
        view.addSubview(incomeHeaderAnimationView)
        view.addSubview(incomeTableView)
        view.addSubview(totalIncomeLabel)
        view.addSubview(expensesHeaderAnimationView)
        view.addSubview(expenseTableView)
        view.addSubview(totalExpenseLabel)
        view.addSubview(totalLabel)
        

        NSLayoutConstraint.activate([
            incomeHeaderAnimationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            incomeHeaderAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            incomeHeaderAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
            incomeHeaderAnimationView.heightAnchor.constraint(equalToConstant: 130),

            incomeTableView.topAnchor.constraint(equalTo: incomeHeaderAnimationView.bottomAnchor, constant: -50),
            incomeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            incomeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            incomeTableView.heightAnchor.constraint(equalToConstant: 230),

            totalIncomeLabel.topAnchor.constraint(equalTo: incomeTableView.bottomAnchor, constant: 15),
            totalIncomeLabel.leadingAnchor.constraint(equalTo: incomeTableView.leadingAnchor),

            expensesHeaderAnimationView.topAnchor.constraint(equalTo: totalIncomeLabel.bottomAnchor, constant: -40),
            expensesHeaderAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expensesHeaderAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
            expensesHeaderAnimationView.heightAnchor.constraint(equalToConstant: 130),

            expenseTableView.topAnchor.constraint(equalTo: expensesHeaderAnimationView.bottomAnchor, constant: -50),
            expenseTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expenseTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expenseTableView.heightAnchor.constraint(equalToConstant: 230),

            totalExpenseLabel.topAnchor.constraint(equalTo: expenseTableView.bottomAnchor, constant: 10),
            totalExpenseLabel.leadingAnchor.constraint(equalTo: expenseTableView.leadingAnchor),

            totalLabel.topAnchor.constraint(equalTo: totalExpenseLabel.bottomAnchor, constant: 10),
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
            let name = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !name.isEmpty else {
                let secAlert = UIAlertController(title: "Oops 😬", message: "Fields can't be empty", preferredStyle: .alert)
                secAlert.addAction(UIAlertAction(title: "Let's try again", style: .default))
                present(secAlert, animated: true)
                return }
            let formattedName = name.prefix(1).uppercased() + name.dropFirst()
            let amount = Double(alert.textFields?[1].text ?? "0") ?? 0
            self.expenses.append(Expense(name: formattedName, amount: amount))
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
            cell.backgroundColor = .clear
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
            cell.backgroundColor = .clear
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
            }
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == incomeTableView {
            return false
        } else if tableView == expenseTableView {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
