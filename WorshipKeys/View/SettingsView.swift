//
//  SettingsView.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 16/05/25.
//

import UIKit

class SettingsView: UIView {

    // MARK: - UIElements
    let scrollView = UIScrollView()
    let contentView = UIView()

    let titleLabel = UILabel()

    let controlsContainer = UIView()
    let volumeLabel = UILabel()
    let volumeSlider = UISlider()
    let outputLabel = UILabel()
    let outputSelector = UISegmentedControl(items: ["L", "L+R", "R"])

    let crossfadeContainer = UIView()
    let crossfadeLabel = UILabel()
    let crossfadeSlider = UISlider()

    let padGuideTitle = UILabel()
    let padGuideStack = UIStackView()

    let aboutLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.background
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        setupElements()
        setHierarchy()
        setConstraints()
    }

    private func setupElements() {
        titleLabel.text = "Settings"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white

        controlsContainer.backgroundColor = UIColor(hex: "#1C1C1E")
        controlsContainer.layer.cornerRadius = 8

        volumeLabel.text = "Master"
        volumeLabel.textColor = .white
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 1
        volumeSlider.value = 0.8
        volumeSlider.tintColor = .lightGray

        outputLabel.text = "Output"
        outputLabel.textColor = .white
        outputSelector.selectedSegmentIndex = 1
        outputSelector.tintColor = .white

        crossfadeContainer.backgroundColor = UIColor(hex: "#1C1C1E")
        crossfadeContainer.layer.cornerRadius = 8

        crossfadeLabel.text = "Crossfade"
        crossfadeLabel.textColor = .white
        crossfadeSlider.minimumValue = 0
        crossfadeSlider.maximumValue = 3
        crossfadeSlider.value = 0
        crossfadeSlider.tintColor = .lightGray

        aboutLabel.text = "WorshipKeys v1.0\nBy João Victor Almeida"
        aboutLabel.textAlignment = .center
        aboutLabel.textColor = .darkGray
        aboutLabel.font = .systemFont(ofSize: 13)
        aboutLabel.numberOfLines = 0
    }

    // MARK: - Hierarquia
    private func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [titleLabel,
         controlsContainer,
         crossfadeContainer,
         padGuideTitle, padGuideStack,
         aboutLabel].forEach { contentView.addSubview($0) }

        [volumeLabel, volumeSlider, outputLabel, outputSelector].forEach { controlsContainer.addSubview($0) }
        [crossfadeLabel, crossfadeSlider].forEach { crossfadeContainer.addSubview($0) }
    }

    // MARK: - Constraints
    private func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let views = [titleLabel,
                     controlsContainer, volumeLabel, volumeSlider, outputLabel, outputSelector,
                     crossfadeContainer, crossfadeLabel, crossfadeSlider, aboutLabel]

        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),

            controlsContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            controlsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            controlsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            volumeLabel.topAnchor.constraint(equalTo: controlsContainer.topAnchor, constant: 16),
            volumeLabel.leadingAnchor.constraint(equalTo: controlsContainer.leadingAnchor, constant: 16),

            volumeSlider.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: 8),
            volumeSlider.leadingAnchor.constraint(equalTo: controlsContainer.leadingAnchor, constant: 16),
            volumeSlider.trailingAnchor.constraint(equalTo: controlsContainer.trailingAnchor, constant: -16),

            outputLabel.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 24),
            outputLabel.leadingAnchor.constraint(equalTo: controlsContainer.leadingAnchor, constant: 16),

            outputSelector.topAnchor.constraint(equalTo: outputLabel.bottomAnchor, constant: 8),
            outputSelector.leadingAnchor.constraint(equalTo: controlsContainer.leadingAnchor, constant: 16),
            outputSelector.trailingAnchor.constraint(equalTo: controlsContainer.trailingAnchor, constant: -16),
            outputSelector.bottomAnchor.constraint(equalTo: controlsContainer.bottomAnchor, constant: -16),

            crossfadeContainer.topAnchor.constraint(equalTo: controlsContainer.bottomAnchor, constant: 24),
            crossfadeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            crossfadeContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            crossfadeLabel.topAnchor.constraint(equalTo: crossfadeContainer.topAnchor, constant: 16),
            crossfadeLabel.leadingAnchor.constraint(equalTo: crossfadeContainer.leadingAnchor, constant: 16),

            crossfadeSlider.topAnchor.constraint(equalTo: crossfadeLabel.bottomAnchor, constant: 8),
            crossfadeSlider.leadingAnchor.constraint(equalTo: crossfadeContainer.leadingAnchor, constant: 16),
            crossfadeSlider.trailingAnchor.constraint(equalTo: crossfadeContainer.trailingAnchor, constant: -16),
            crossfadeSlider.bottomAnchor.constraint(equalTo: crossfadeContainer.bottomAnchor, constant: -28),

            aboutLabel.topAnchor.constraint(equalTo: crossfadeContainer.bottomAnchor, constant: 40),
            aboutLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            aboutLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
}



