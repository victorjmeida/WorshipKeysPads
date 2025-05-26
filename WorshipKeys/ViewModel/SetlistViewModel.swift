//
//  SetlistViewModel.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 17/05/25.
//
import Foundation

class SetlistViewModel {
    private(set) var items: [SetlistItem] = []
    private let manager = SetlistManager()

    var onUpdate: (() -> Void)?

    init() {
        loadItems()
    }

    func numberOfItems() -> Int {
        items.count
    }

    func item(at index: Int) -> SetlistItem {
        items[index]
    }

    func addItem(_ item: SetlistItem) {
        items.append(item)
        manager.save(items)
        onUpdate?()
    }

    func deleteItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
        manager.save(items)
        onUpdate?()
    }

    func updateItem(at index: Int, with newItem: SetlistItem) {
        guard items.indices.contains(index) else { return }
        items[index] = newItem
        manager.save(items)
        onUpdate?()
    }

    private func loadItems() {
        items = manager.load()
        onUpdate?()
    }
}


