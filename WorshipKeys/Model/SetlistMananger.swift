//
//  SetlistMananger.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 17/05/25.
//

import Foundation

class SetlistManager {
    private let key = "setlist_items"

    func save(_ items: [SetlistItem]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> [SetlistItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([SetlistItem].self, from: data) else {
            return []
        }
        return items
    }
}
