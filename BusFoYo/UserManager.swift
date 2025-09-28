//
//  UserManager.swift
//  BusFoYo
//
//  Created by Stepan on 27.09.2025.
//

import Foundation

struct User: Codable {
    let username: String
    let company: String
    let pin: String
}

final class UserManager {
    static let shared = UserManager()
    private let defaults = UserDefaults.standard
    private let key = "currentUser"

    var currentUser: User? {
        guard let data = defaults.data(forKey: key),
              let user = try? JSONDecoder().decode(User.self, from: data) else { return nil }
        return user
    }

    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            defaults.set(data, forKey: key)
        }
    }

    func removeCurrentUser() {
        defaults.removeObject(forKey: key)
    }
}
