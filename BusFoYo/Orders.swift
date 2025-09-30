//
//  Orders.swift
//  BusFoYo
//
//  Created by Stepan on 30.09.2025.
//

import Foundation

struct Order {
    let id: UUID
    var clientName: String
    var clientAgw: String?
    var orderDate: Date         
    var deadline: Date
    var isPaid: Bool
    var description: String?
}
