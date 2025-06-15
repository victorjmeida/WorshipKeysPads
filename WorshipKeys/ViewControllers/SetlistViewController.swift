//
//  SetlistViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 16/05/25.
//

import UIKit

class SetlistViewController: UIViewController {

    private let mainView = SetlistView()
    private let viewModel = SetlistViewModel()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - TableView
    private func setupTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }

    // MARK: - Bind ViewModel
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.mainView.tableView.reloadData()
            }
        }
    }

    // MARK: - Actions
    private func setupActions() {
        mainView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    @objc private func addButtonTapped() {
        presentCreatePreset()
    }

    func presentCreatePreset() {
        let createVC = CreatePresetViewController()

        createVC.onPresetCreated = { [weak self] preset in
            self?.viewModel.addItem(preset)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.navigateToMainPad(with: preset)
            }
        }

        present(createVC, animated: true)
    }

    func navigateToMainPad(with preset: SetlistItem) {
        let mainVC = MainPadViewController()
        mainVC.applyPreset(preset)

        print("🧭 navigationController é:", navigationController as Any)
        
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
}

// MARK: - TableView DataSource & Delegate
extension SetlistViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetlistCell", for: indexPath)

        let item = viewModel.item(at: indexPath.row)
        cell.textLabel?.text = item.name
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteItem(at: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let preset = viewModel.item(at: indexPath.row)
        print("Preset selecionado: \(preset.name)")
        navigateToMainPad(with: preset)
    }
}

