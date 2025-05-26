//
//  CreatepresetView.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 17/05/25.
//

import UIKit

class CreatePresetView: UIView {
    
    // MARK: - UI Elements
    let nameTextField = UITextField()
    let tonesStackView = UIStackView()
    var toneButtons: [UIButton] = []
    
    let padScrollView = UIScrollView()
    let padStackView = UIStackView()
    var padButtons: [UIButton] = []
    
    let lowCutSlider = UISlider()
    let highCutSlider = UISlider()
    let saveButton = UIButton(type: .system)
    
    let lowCutLabel = UILabel()
    let highCutLabel = UILabel()
    
    let defaultToneButtonColor = UIColor.darkGray
    
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
        configureElements()
        setHierarchy()
        setupToneButtons()
        setupPadButtons()
        setConstraints()
    }
    
    // MARK: - Element Configuration
    private func configureElements() {
        nameTextField.placeholder = "Nome do preset"
        nameTextField.borderStyle = .roundedRect
        nameTextField.backgroundColor = .lightGray
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        tonesStackView.axis = .vertical
        tonesStackView.spacing = 12
        tonesStackView.distribution = .fillEqually
        tonesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        padScrollView.showsHorizontalScrollIndicator = false
        padScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        padStackView.axis = .horizontal
        padStackView.spacing = 12
        padStackView.alignment = .center
        padStackView.distribution = .equalSpacing
        padStackView.translatesAutoresizingMaskIntoConstraints = false
        
        lowCutLabel.text = "Low Cut"
        lowCutLabel.textColor = .white
        lowCutLabel.font = .systemFont(ofSize: 16, weight: .medium)
        lowCutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        lowCutSlider.minimumValue = 20
        lowCutSlider.maximumValue = 600
        lowCutSlider.value = 80
        lowCutSlider.tintColor = .lightGray
        lowCutSlider.translatesAutoresizingMaskIntoConstraints = false
        
        highCutLabel.text = "High Cut"
        highCutLabel.textColor = .white
        highCutLabel.font = .systemFont(ofSize: 16, weight: .medium)
        highCutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        highCutSlider.minimumValue = -18
        highCutSlider.maximumValue = 0
        highCutSlider.value = 0
        highCutSlider.tintColor = .lightGray
        highCutSlider.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Salvar", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Hierarchy
    private func setHierarchy() {
        addSubview(nameTextField)
        addSubview(tonesStackView)
        addSubview(padScrollView)
        padScrollView.addSubview(padStackView)
        addSubview(lowCutLabel)
        addSubview(lowCutSlider)
        addSubview(highCutLabel)
        addSubview(highCutSlider)
        addSubview(saveButton)
    }
    
    // MARK: - Tone Buttons
    private func setupToneButtons() {
        let tones = Tone.allCases
        let tonesPerRow = 4
        
        for rowIndex in stride(from: 0, to: tones.count, by: tonesPerRow) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            rowStack.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            for column in 0..<tonesPerRow {
                let index = rowIndex + column
                guard index < tones.count else { break }
                let tone = tones[index]
                
                let button = createToneButton(title: tone.displayName, tag: index)
                toneButtons.append(button)
                rowStack.addArrangedSubview(button)
            }
            
            tonesStackView.addArrangedSubview(rowStack)
        }
    }
    
    private func createToneButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = defaultToneButtonColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Pad Buttons
    func setupPadButtons() {
        let screenWidth = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 24 * 2
        let spacing: CGFloat = 16 * 2
        let buttonWidth = ((screenWidth - horizontalPadding - spacing) / 3) + 16
        
        let backgroundImages = [
            "pad_base",
            "pad_shimmer",
            "pad_shiny",
            "pad_warm",
            "pad_reverse",
            "pad_vassal"
        ]
        
        for (index, style) in PadStyle.allCases.enumerated() {
            let button = createPadButton(backgroundImageName: backgroundImages[index], size: buttonWidth, tag: index)
            padButtons.append(button)
            
            let label = UILabel()
            label.text = style.rawValue.capitalized
            label.textColor = .white
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            
            let container = UIStackView(arrangedSubviews: [button, label])
            container.axis = .vertical
            container.alignment = .center
            container.spacing = 4
            
            padStackView.addArrangedSubview(container)
        }
    }
    
    func createPadButton(backgroundImageName: String, size: CGFloat, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        
        if let backgroundImage = UIImage(named: backgroundImageName) {
            button.setBackgroundImage(backgroundImage, for: .normal)
        }
        
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.tag = tag
        
        return button
    }
    
        // MARK: - Constraints
        private func setConstraints() {
            NSLayoutConstraint.activate([
                nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
                nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                nameTextField.heightAnchor.constraint(equalToConstant: 44),
                
                tonesStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 22),
                tonesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                tonesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                
                padScrollView.topAnchor.constraint(equalTo: tonesStackView.bottomAnchor, constant: 22),
                padScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                padScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                padScrollView.heightAnchor.constraint(equalToConstant: 140),
                
                padStackView.topAnchor.constraint(equalTo: padScrollView.topAnchor),
                padStackView.bottomAnchor.constraint(equalTo: padScrollView.bottomAnchor),
                padStackView.leadingAnchor.constraint(equalTo: padScrollView.leadingAnchor, constant: 24),
                padStackView.trailingAnchor.constraint(equalTo: padScrollView.trailingAnchor, constant: -24),
                padStackView.heightAnchor.constraint(equalTo: padScrollView.heightAnchor),
                
                lowCutLabel.topAnchor.constraint(equalTo: padScrollView.bottomAnchor, constant: 24),
                lowCutLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                
                lowCutSlider.topAnchor.constraint(equalTo: lowCutLabel.bottomAnchor, constant: 8),
                lowCutSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                lowCutSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                
                highCutLabel.topAnchor.constraint(equalTo: lowCutSlider.bottomAnchor, constant: 24),
                highCutLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                
                highCutSlider.topAnchor.constraint(equalTo: highCutLabel.bottomAnchor, constant: 8),
                highCutSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                highCutSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                
                saveButton.topAnchor.constraint(equalTo: highCutSlider.bottomAnchor, constant: 28),
                saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
        // MARK: - Visual Feedback
        func highlightButton(_ button: UIButton?) {
            guard let button = button else { return }
            UIView.animate(withDuration: 0.3) {
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.white.cgColor
                button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
            }
        }
        
        func resetButtonAppearance(_ button: UIButton?) {
            guard let button = button else { return }
            UIView.animate(withDuration: 0.3) {
                button.layer.borderWidth = 0
                button.backgroundColor = .darkGray
            }
        }
    }
    
