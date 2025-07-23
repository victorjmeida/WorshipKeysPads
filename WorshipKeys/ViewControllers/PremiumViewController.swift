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
            showAlert(title: "Attention", message: "Purchase requires iOS 15 or later.")
        }
    }

    @objc private func restoreTapped() {
        if #available(iOS 15.0, *) {
            Task {
                await restorePurchases()
            }
        } else {
            showAlert(title: "Attention", message: "Restore requires iOS 15 or later.")
        }
    }

    // MARK: - StoreKit 2
    @available(iOS 15.0, *)
    private func purchasePremiumPads() async {
        do {
            let products = try await Product.products(for: [premiumProductID])
            guard let product = products.first else {
                showAlert(title: "Error", message: "Product not found.")
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
                    showAlert(title: "Error", message: "Unable to verify purchase.")
                }
            case .userCancelled:
                break
            default:
                showAlert(title: "Error", message: "Unable to complete purchase.")
            }
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
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
            title: found ? "Restored!" : "No purchases found.",
            message: found ? "Premium successfully restored!" : "You have no purchases to restore."
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



