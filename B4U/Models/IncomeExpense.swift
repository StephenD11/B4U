//
//  IncomeExpense.swift
//  BusFoYo
//
//  Created by Stepan on 09.10.2025.
//
import UIKit
import Foundation

struct Income: Codable {
    var clientName: String
    var totalPrice: Double
}

struct Expense: Codable {
    var name: String
    var amount: Double
}

