//
//  PremiumViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 26/05/25.
//

import UIKit
import StoreKit

class PremiumViewController: UIViewController {

    private let mainView = PremiumView()
    private let premiumProductID = "exclusivepads"

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
    }

    private func setupActions() {
        mainView.buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        mainView.restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func buyTapped() {
        if #available(iOS 15.0, *) {
            Task {
                await purchasePremiumPads()
            }
        } else {
            showAlert(title: "Atenção", message: "A compra exige iOS 15 ou superior.")
        }
    }

    @objc private func restoreTapped() {
        if #available(iOS 15.0, *) {
            Task {
                await restorePurchases()
            }
        } else {
            showAlert(title: "Atenção", message: "A restauração exige iOS 15 ou superior.")
        }
    }

    // MARK: - StoreKit 2

    @available(iOS 15.0, *)
    private func purchasePremiumPads() async {
        do {
            let products = try await Product.products(for: [premiumProductID])
            guard let product = products.first else {
                showAlert(title: "Erro", message: "Produto não encontrado.")
                return
            }

            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    UserDefaults.standard.set(true, forKey: "isPremiumUser")
                    showAlert(title: "Success!", message: "Worship Premium unlocked.") {
                        self.dismiss(animated: true)
                    }
                case .unverified:
                    showAlert(title: "Erro", message: "Não foi possível verificar a compra.")
                }
            case .userCancelled:
                break // Usuário cancelou, não faz nada
            default:
                showAlert(title: "Erro", message: "Não foi possível concluir a compra.")
            }
        } catch {
            showAlert(title: "Erro", message: error.localizedDescription)
        }
    }

    @available(iOS 15.0, *)
    private func restorePurchases() async {
        var found = false
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == premiumProductID {
                    UserDefaults.standard.set(true, forKey: "isPremiumUser")
                    found = true
                }
            case .unverified:
                break
            }
        }
        showAlert(
            title: found ? "Restaurado!" : "Nenhuma compra encontrada",
            message: found ? "Premium restaurado com sucesso!" : "Você não possui compras para restaurar."
        )
    }

    // MARK: - Alert Helper

    @MainActor
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// Global helper (pode estar em outro arquivo)
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



