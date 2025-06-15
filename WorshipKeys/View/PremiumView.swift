//
//  PremiumView.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 26/05/25.
//

import UIKit

class PremiumView: UIView {

    // MARK: - UI Elements
    let logoApp = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let benefitsStack = UIStackView()
    let buyButton = UIButton(type: .system)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.background
        setupView()
        setHierarchy()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        
        logoApp.image = UIImage(named: "WorshipKeysBack")
        logoApp.contentMode = .scaleAspectFit
        logoApp.clipsToBounds = true
        logoApp.layer.cornerRadius = 4
        
        titleLabel.text = "Unlock Worship Keys"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        subtitleLabel.text = "Full access to the best pad styles for your sound and extra features."
        subtitleLabel.textColor = .lightGray
        subtitleLabel.font = .systemFont(ofSize: 18)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        benefitsStack.axis = .vertical
        benefitsStack.spacing = 12
        benefitsStack.alignment = .leading

        let benefits = [
            "Five more pad styles",
            "Shimmer, Shiny, Warm, Reverse, Vassal",
            "Your most professional ministrations",
            "Future updates included"
        ]

        for benefit in benefits {
            let label = UILabel()
            label.text = "• \(benefit)"
            label.textColor = .lightGray
            label.font = .systemFont(ofSize: 16)
            label.numberOfLines = 0
            benefitsStack.addArrangedSubview(label)
        }

        buyButton.setTitle("Unlock Now", for: .normal)
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        buyButton.backgroundColor = UIColor(hex: "#815778")
        buyButton.layer.cornerRadius = 10
        buyButton.clipsToBounds = true

    }

    // MARK: - Hierarquia
    private func setHierarchy() {
        addSubview(logoApp)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(benefitsStack)
        addSubview(buyButton)
    }

    // MARK: - Constraints
    private func setConstraints() {
        [logoApp, titleLabel, subtitleLabel, benefitsStack, buyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            logoApp.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            logoApp.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoApp.heightAnchor.constraint(equalToConstant: 260),
            logoApp.widthAnchor.constraint(equalToConstant: 260),
            
            titleLabel.topAnchor.constraint(equalTo: logoApp.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            benefitsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            benefitsStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            benefitsStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            buyButton.topAnchor.constraint(equalTo: benefitsStack.bottomAnchor, constant: 24),
            buyButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buyButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buyButton.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
}

#if swift(>=5.9)
@available(iOS 17.0,*)
#Preview(traits: .portrait, body: {
    PremiumView()
})
#endif
