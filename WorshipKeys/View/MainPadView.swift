//
//  MainPadView.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 10/04/25.
//

import UIKit

class MainPadView: UIView {
    
    //MARK: - UIElements
    private let padPlayingBar = UIView()
    private let tonesStackView = UIStackView()
    private let padScrollView = UIScrollView()
    private let padStackView = UIStackView()
    private let cutControlStackView = UIStackView()
    private let highCutLabel = UILabel()
    private let highCutSlider = UISlider()
    private let lowCutLabel = UILabel()
    private let lowCutSlider = UISlider()
    
    //MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.background
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    private func setupView() {
        setHierarchy()
        setupPadPlayingBar()
        setupToneButtons()
        
        setupPadButtons()
        setupCutControls()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubview(padPlayingBar)
        addSubview(tonesStackView)
        addSubview(padScrollView)
        padScrollView.addSubview(padStackView)
        addSubview(cutControlStackView)
    }
    
    //PLAYINGBAR
    private func setupPadPlayingBar() {
        padPlayingBar.translatesAutoresizingMaskIntoConstraints = false
        padPlayingBar.backgroundColor = UIColor(named: "toneBackground") ?? .darkGray
        padPlayingBar.alpha = 1
    }
    
    //TONES
    private func setupToneButtons() {
        tonesStackView.axis = .vertical
        tonesStackView.spacing = 16
        tonesStackView.distribution = .fillEqually
        
        let tones = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        var currentIndex = 0
        
        for _ in 0..<3 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually
            
            for _ in 0..<4 {
                let tone = tones[currentIndex]
                let button = UIButton(type: .system)
                button.setTitle(tone, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(named: "toneBackground") ?? .darkGray
                button.layer.cornerRadius = 8
                button.tag = currentIndex
                rowStack.addArrangedSubview(button)
                currentIndex += 1
            }
            rowStack.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            tonesStackView.addArrangedSubview(rowStack)
        }
    }
    
    //STYLES
    private func setupPadButtons() {
        padScrollView.showsHorizontalScrollIndicator = false
        
        padStackView.axis = .horizontal
        padStackView.spacing = 16
        padStackView.alignment = .center
        padStackView.distribution = .equalSpacing
        
        let padStyles = ["Base", "Shimmer", "Shiny", "Warm", "Reverse", "Vassal"]
        let padSystemIcons = [
            "music.note",             // Base
            "sparkles",               // Shimmer
            "sun.max",                // Shiny
            "flame",                  // Warm
            "backward.end.alt",       // Reverse
            "waveform"                // Vassal
        ]
        
        // Calcular tamanho ideal para 3 botões visíveis com espaçamento
        let screenWidth = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 24 * 2 // 24 de cada lado
        let spacing: CGFloat = 16 * 2 // dois espaços de 16 entre três botões
        let buttonWidth = ((screenWidth - horizontalPadding - spacing) / 3) + 16
        
        for (index, iconName) in padSystemIcons.enumerated() {
                let button = UIButton(type: .system)
                let image = UIImage(systemName: iconName)

            button.setImage(image, for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor(named: "toneBackground") ?? .darkGray
            button.imageView?.contentMode = .scaleAspectFit
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.tag = index


                // Optional: adicionar título abaixo (estilizado)
                let label = UILabel()
                label.text = padStyles[index]
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
    
    //CUTS
    private func setupCutControls() {
        cutControlStackView.axis = .vertical
        cutControlStackView.spacing = 24
        cutControlStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //HIGHCUT
        highCutLabel.text = "High Cut"
        highCutLabel.textColor = .white
        highCutLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        highCutSlider.minimumValue = 0
        highCutSlider.maximumValue = 100
        highCutSlider.tintColor = .systemTeal
        
        //LOWCUT
        lowCutLabel.text = "Low Cut"
        lowCutLabel.textColor = .white
        lowCutLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        lowCutSlider.minimumValue = 0
        lowCutSlider.maximumValue = 100
        lowCutSlider.tintColor = .systemOrange
        
        // Agrupar cada controle em uma stack horizontal
        let highCutStack = UIStackView(arrangedSubviews: [highCutLabel, highCutSlider])
        highCutStack.axis = .vertical
        highCutStack.spacing = 8

        let lowCutStack = UIStackView(arrangedSubviews: [lowCutLabel, lowCutSlider])
        lowCutStack.axis = .vertical
        lowCutStack.spacing = 8

        // Adiciona os dois ao stack principal
        cutControlStackView.addArrangedSubview(highCutStack)
        cutControlStackView.addArrangedSubview(lowCutStack)
    }
    
    //MARK: Constrains
    private func setConstraints() {
        tonesStackView.translatesAutoresizingMaskIntoConstraints = false
        padScrollView.translatesAutoresizingMaskIntoConstraints = false
        padStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Tons
            tonesStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 36),
            tonesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            tonesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            // Scroll dos pads
            padScrollView.topAnchor.constraint(equalTo: tonesStackView.bottomAnchor, constant: 42),
            padScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            padScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            padScrollView.heightAnchor.constraint(equalToConstant: 140),

            // Stack interno do scroll
            padStackView.topAnchor.constraint(equalTo: padScrollView.topAnchor),
            padStackView.bottomAnchor.constraint(equalTo: padScrollView.bottomAnchor),
            padStackView.leadingAnchor.constraint(equalTo: padScrollView.leadingAnchor, constant: 24),
            padStackView.trailingAnchor.constraint(equalTo: padScrollView.trailingAnchor, constant: -24),
            padStackView.heightAnchor.constraint(equalTo: padScrollView.heightAnchor),
            
            //CutControl
           // cutControlStackView.topAnchor.constraint(equalTo: padScrollView.bottomAnchor, constant: 32),
            cutControlStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            cutControlStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            cutControlStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -48),
            
            //PlayingBar
            padPlayingBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            padPlayingBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            padPlayingBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            padPlayingBar.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
}
