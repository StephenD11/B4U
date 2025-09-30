//
//  OrdersViewController.swift
//  BusFoYo
//
//  Created by Stepan on 29.09.2025.
//


import UIKit

class OrdersViewController: UIViewController, NewOrderDelegate{
    
    var ordersByMonth: [String: [Order]] = [:]
    var allOrdersByMonth: [String: [Order]] = [:]
    
    var sortedMonths: [String] = []
    var activeMonths: [String] {
        return sortedMonths.filter { (ordersByMonth[$0]?.count ?? 0) > 0 }
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
            textField.backgroundColor = .white
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
        return tv
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Orders"
        
        setupUI()
        setupDummyData()
        
        searchBar.delegate = self
        
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
    
    func setupDummyData() {
        let months = Calendar.current.monthSymbols
        sortedMonths = months
        for month in months {
            ordersByMonth[month] = []
        }

        let order = Order(
            id: UUID(),
            clientName: "Rock H.H",
            orderDate: Date(),
            deadline: Date().addingTimeInterval(86400),
            isPaid: true,
            description: "Testing order"
        )

        let monthIndex = Calendar.current.component(.month, from: order.orderDate) - 1
        let monthName = sortedMonths[monthIndex]
        ordersByMonth[monthName]?.append(order)
        
        allOrdersByMonth = ordersByMonth

    }
    
    
    func addOrder(_ order: Order) {
        let monthIndex = Calendar.current.component(.month, from: order.orderDate) - 1
        let monthName = sortedMonths[monthIndex]
        
        ordersByMonth[monthName]?.append(order)
        tabView.reloadData()
    }
    
    @objc func addNewOrderTapped() {
        let newOrderVC = NewOrderViewController()
        newOrderVC.delegate = self  
        navigationController?.pushViewController(newOrderVC, animated: true)
    }
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        let month = activeMonths[indexPath.section]
        
        if let order = ordersByMonth[month]?[indexPath.row] {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let dateString = formatter.string(from: order.orderDate)
            
            let paidStatus = order.isPaid ? "✅" : "❌"
            let clientText = order.clientName
            let orderNumberText = "ORDER: \(globalOrderNumber(for: indexPath))"

    
            let fullText = "\(orderNumberText) \nClient: \(clientText) • Data: \(dateString) • Paid: \(paidStatus)"
            let attributedText = NSMutableAttributedString(string: fullText)
            
            
            let orderRange = (fullText as NSString).range(of: orderNumberText)
            attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 15)], range: orderRange)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, fullText.count))

            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.attributedText = attributedText        }
        
        return cell
    }
    
    //Count all orders
    func globalOrderNumber(for indexPath: IndexPath) -> Int {
        var number = 0
        for i in 0..<indexPath.section {
            let month = activeMonths[i]
            number += ordersByMonth[month]?.count ?? 0
        }
        number += indexPath.row + 1
        return number
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

