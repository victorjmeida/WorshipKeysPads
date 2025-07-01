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
    let restoreButton = UIButton(type: .system)

    // MARK: - Texts (para manutenção e tradução futura)
    private let logoName = "WorshipKeysBack"
    private let titleText = "Unlock Worship Keys"
    private let subtitleText = "Full access to the best pad styles for your sound and extra features."
    private let benefits: [String] = [
        "Five more pad styles",
        "Shimmer, Shiny, Warm, Reverse, Vassal",
        "Your most professional ministrations",
        "Future updates included"
    ]
    private let buyButtonTitle = "Unlock Now"
    private let restoreButtonTitle = "Restore Purchase"

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.background
        configure()
        buildHierarchy()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    private func configure() {
        configureLogo()
        configureTitle()
        configureSubtitle()
        configureBenefitsStack()
        configureBuyButton()
        configureRestoreButton()
    }

    private func configureLogo() {
        logoApp.image = .worshipKeys
        logoApp.contentMode = .scaleAspectFit
        logoApp.clipsToBounds = true
        logoApp.layer.cornerRadius = 4
    }

    private func configureTitle() {
        titleLabel.text = titleText
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }

    private func configureSubtitle() {
        subtitleLabel.text = subtitleText
        subtitleLabel.textColor = .lightGray
        subtitleLabel.font = .systemFont(ofSize: 18)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
    }

    private func configureBenefitsStack() {
        benefitsStack.axis = .vertical
        benefitsStack.spacing = 12
        benefitsStack.alignment = .leading
        benefitsStack.distribution = .equalSpacing
        benefitsStack.arrangedSubviews.forEach { benefitsStack.removeArrangedSubview($0); $0.removeFromSuperview() }
        benefits.forEach { addBenefit($0) }
    }

    private func addBenefit(_ text: String) {
        let label = UILabel()
        label.text = "• \(text)"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        benefitsStack.addArrangedSubview(label)
    }

    private func configureBuyButton() {
        buyButton.setTitle(buyButtonTitle, for: .normal)
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        buyButton.backgroundColor = UIColor(hex: "#815778")
        buyButton.layer.cornerRadius = 10
        buyButton.clipsToBounds = true
    }

    private func configureRestoreButton() {
        restoreButton.setTitle(restoreButtonTitle, for: .normal)
        restoreButton.setTitleColor(.white, for: .normal)
        restoreButton.titleLabel?.font = .systemFont(ofSize: 16)
        restoreButton.backgroundColor = .clear
    }

    // MARK: - Hierarchy
    private func buildHierarchy() {
        addSubview(logoApp)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(benefitsStack)
        addSubview(buyButton)
        addSubview(restoreButton)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        [logoApp, titleLabel, subtitleLabel, benefitsStack, buyButton, restoreButton].forEach {
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

            restoreButton.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 8),
            restoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            restoreButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

#if swift(>=5.9)
@available(iOS 17.0,*)
#Preview(traits: .portrait, body: {
    PremiumView()
})
#endif

