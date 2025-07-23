//
//  PadGuideCardView.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 14/06/25.
//

import UIKit

class PadGuideCardView: UIView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    init(icon: UIImage, title: String, description: String) {
        super.init(frame: .zero)
        setupView()
        configure(icon: icon, title: title, description: description)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 12
        backgroundColor = UIColor(hex: "#1C1C1E")
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        iconImageView.tintColor = .white

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .lightGray
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let mainStack = UIStackView(arrangedSubviews: [iconImageView, textStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12

        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    private func configure(icon: UIImage, title: String, description: String) {
        iconImageView.image = icon
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
