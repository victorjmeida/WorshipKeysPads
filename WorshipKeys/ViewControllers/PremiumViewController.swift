//
//  PremiumViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 26/05/25.
//

import UIKit

class PremiumViewController: UIViewController {

    private let mainView = PremiumView()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupNavigation()
    }

    private func setupNavigation() {
        navigationItem.title = "Premium"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(closeTapped))
    }

    private func setupActions() {
        mainView.buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func buyTapped() {
        // Marca como premium
        UserDefaults.standard.set(true, forKey: "isPremiumUser")

        let alert = UIAlertController(title: "Sucesso!",
                                      message: "Worship Premium foi desbloqueado.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    @objc private func restoreTapped() {
        // Placeholder de restauração (StoreKit no futuro)
        let alert = UIAlertController(title: "Restauração",
                                      message: "Função de restaurar compra ainda não implementada.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

struct PremiumAccess {
    static var isUnlocked: Bool {
        return UserDefaults.standard.bool(forKey: "isPremiumUser")
    }
}

#if swift(>=5.9)
@available(iOS 17.0,*)
#Preview(traits: .portrait, body: {
    PremiumViewController()
})
#endif

