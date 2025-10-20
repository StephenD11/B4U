//
//  OrdersViewController.swift
//  BusFoYo
//
//  Created by Stephan on 07.10.2025.
//


import UIKit

class OrdersViewController: UIViewController, NewOrderDelegate{
    
    let backgroundImageView = UIImageView(image: UIImage(named: "Background2"))

    
    var ordersByMonth: [String: [Order]] = [:]
    var allOrdersByMonth: [String: [Order]] = [:]
    
    weak var calculationsVC: CalculationsViewController?
    
    var sortedMonths: [String] = []
    var activeMonths: [String] {
        return ordersByMonth
            .filter { !$0.value.isEmpty }
            .keys
            .sorted { key1, key2 in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "LLLL yyyy"
                let date1 = dateFormatter.date(from: key1) ?? Date.distantPast
                let date2 = dateFormatter.date(from: key2) ?? Date.distantPast
                return date1 > date2
            }
    }
    
    
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Search order by username"
        sb.layer.cornerRadius = 12
        sb.clipsToBounds = true
        
        sb.backgroundImage = UIImage()
        sb.barTintColor = .clear
        sb.searchBarStyle = .minimal
        
        if let textField = sb.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.white
            }
            textField.textColor = .label
            if let placeholder = textField.placeholder {
                textField.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [.foregroundColor: UIColor.secondaryLabel]
                )
            }
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
        }
        
        return sb
    }()
    
    
    lazy var tabView: UITableView = {
       let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.layer.cornerRadius = 12
        tv.clipsToBounds = true
        tv.backgroundColor = .none
        return tv
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Orders"

        loadOrders()
        setupUI()
        setupDummyDataIfNeeded()
        updateTableBackground()

        searchBar.delegate = self
        
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
        
    }
    
    
    
    
    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tabView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewOrderTapped))
        
        
        NSLayoutConstraint.activate ([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tabView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

    }
    
    
    func setupDummyDataIfNeeded() {
        if allOrdersByMonth.isEmpty {
            ordersByMonth = [:]
            allOrdersByMonth = [:]
            saveOrders()
        } else {
            ordersByMonth = allOrdersByMonth
        }
    }
    
    func addOrder(_ order: Order) {
        let newMonth = order.monthName

        for (month, orders) in ordersByMonth {
                if let index = orders.firstIndex(where: { $0.id == order.id }) {
                    var monthOrders = orders
                    monthOrders.remove(at: index)
                    ordersByMonth[month] = monthOrders
                }
            }
            
            if var monthOrders = ordersByMonth[newMonth] {
                monthOrders.append(order)
                ordersByMonth[newMonth] = monthOrders
            } else {
                ordersByMonth[newMonth] = [order]
            }
        
        allOrdersByMonth = ordersByMonth
        tabView.reloadData()
        updateTableBackground()
        saveOrders()

    }
    
    @objc func addNewOrderTapped() {
        let newOrderVC = NewOrderViewController()
        newOrderVC.delegate = self
        newOrderVC.incomeDelegate = calculationsVC

        let orderNumber = allOrdersByMonth.values.flatMap { $0 }.count + 1
        newOrderVC.orderNumber = orderNumber

        navigationController?.pushViewController(newOrderVC, animated: true)
    }
    
    func saveOrders() {
        guard let currentUser = UserManager.shared.currentUser else { return }
        let key = "allOrders_\(currentUser.username)"
        if let data = try? JSONEncoder().encode(allOrdersByMonth) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadOrders() {
        guard let currentUser = UserManager.shared.currentUser else { return }
        let key = "allOrders_\(currentUser.username)"
        if let data = UserDefaults.standard.data(forKey: key),
           let savedOrders = try? JSONDecoder().decode([String: [Order]].self, from: data) {
            ordersByMonth = savedOrders
            allOrdersByMonth = savedOrders
            sortedMonths = Calendar.current.monthSymbols
        }
    }
    
    func deleteOrder(at index: Int, month: String) {
        guard var monthOrders = ordersByMonth[month] else { return }

        monthOrders.remove(at: index)
        ordersByMonth[month] = monthOrders
        allOrdersByMonth[month] = monthOrders

        tabView.reloadData()
        updateTableBackground()
        saveOrders()
    }
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let month = activeMonths[indexPath.section]

        guard let orders = ordersByMonth[month], indexPath.row < orders.count else { return }

        let order = orders[indexPath.row]

        let detailVC = OrderDetailViewController(order: order)
        detailVC.delegate = self
        detailVC.incomeDelegate = calculationsVC
        detailVC.monthName = month
        detailVC.indexInMonth = indexPath.row
        detailVC.orderNumber = globalOrderNumber(for: indexPath)

        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activeMonths.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = activeMonths[section]
        return ordersByMonth[month]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return activeMonths[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        let month = activeMonths[indexPath.section]
        
        guard let orders = ordersByMonth[month], indexPath.row < orders.count else {
            cell.textLabel?.text = ""
            return cell
        }
        
        let order = orders[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: order.orderDate)
        
        let clientText = order.clientName
        let fullText = "📍 Client: \(clientText) • Date: \(dateString)"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        let orderRange = (fullText as NSString).range(of: clientText)
        attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 15)], range: orderRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, fullText.count))
        
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.lineBreakMode = .byTruncatingTail
        cell.textLabel?.attributedText = attributedText
        
        cell.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = .label
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.clipsToBounds = true
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func globalOrderNumber(for indexPath: IndexPath) -> Int {
        var number = 0
        for i in 0..<indexPath.section {
            let month = activeMonths[i]
            number += ordersByMonth[month]?.count ?? 0
        }
        number += indexPath.row + 1
        return number
    }
    
    func updateTableBackground() {
        let hasOrders = ordersByMonth.values.flatMap { $0 }.count > 0
        
        if hasOrders {
            tabView.backgroundView = nil
        } else {
            let label = UILabel()
            label.text = "No orders yet. Please add new one"
            label.textColor = .gray
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 16)
            tabView.backgroundView = label
        }
    }

    
}
    
extension OrdersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            ordersByMonth = allOrdersByMonth
        } else {
            var filtered: [String: [Order]] = [:]
            for (month, orders) in allOrdersByMonth {
                filtered[month] = orders.filter { $0.clientName.lowercased().contains(searchText.lowercased()) }
            }
            ordersByMonth = filtered
        }
        
        tabView.reloadData()
    }
    
    
}
