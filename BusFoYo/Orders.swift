//
//  Orders.swift
//  BusFoYo
//
//  Created by Stepan on 30.09.2025.
//

import Foundation

struct Order: Codable, Identifiable{
    let id: UUID
    var clientName: String
    var totalPrice: String?
    var orderDate: Date         
    var deadline: Date
    var isPaid: Bool
    var description: String?
    
    var monthName: String {
        let calendar = Calendar.current
        let monthIndex = calendar.component(.month, from: orderDate) - 1
        let year = calendar.component(.year, from: orderDate)
        return "\(calendar.monthSymbols[monthIndex]) \(year)"
    }
}
