//
//  SettingsViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 16/05/25.
//

import UIKit

class SettingsViewController: UIViewController {

    private let mainView = SettingsView()
    private let viewModel = SettingsViewModel.shared

    private let fadeValueLabel = UILabel()

    // Referência à instância usada no app
    private let padViewModel = MainPadViewModel.shared

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialValues()
        setupActions()
        setupFadeLabel()
        addPadGuideCards()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func addPadGuideCards() {
        let guideCards: [(String, String, String)] = [
            ("pad_base", "Base", "A filling and calm sound that will make the bed for your playing."),
            ("pad_shimmer", "Shimmer", "Bright and strong, like a sharp arrow to create layers in your playing."),
            ("pad_shiny", "Shiny", "Crisp and bright, perfect for inspiring uplifting moments and calm foundations."),
            ("pad_warm", "Warm", "Loud as thunder, the perfect sound to create strength and fill every band in your song."),
            ("pad_reverse", "Reverse", "Sound-based and effects to bring deep ideas to your musical construction."),
            ("pad_vassal", "Vassal", "Strong as a multi-voiced choir, this sound takes your music to a higher level.")
        ]

        for (iconName, title, description) in guideCards {
            let image = UIImage(named: iconName) ?? UIImage(systemName: iconName) ?? UIImage()
            let card = PadGuideCardView(
                icon: image,
                title: title,
                description: description
            )
            mainView.padGuideStack.addArrangedSubview(card)
        }
    }


    private func setupInitialValues() {
        mainView.volumeSlider.value = viewModel.masterVolume
        mainView.crossfadeSlider.value = Float(viewModel.fadeInDuration)
        updateFadeLabel(with: viewModel.fadeInDuration)
    }

    private func setupActions() {
        mainView.volumeSlider.addTarget(self, action: #selector(volumeChanged(_:)), for: .valueChanged)
        mainView.crossfadeSlider.addTarget(self, action: #selector(crossfadeChanged(_:)), for: .valueChanged)
        mainView.outputSelector.addTarget(self, action: #selector(outputChanged(_:)), for: .valueChanged)
    }

    private func setupFadeLabel() {
        fadeValueLabel.textColor = .lightGray
        fadeValueLabel.font = .systemFont(ofSize: 13)
        fadeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.crossfadeContainer.addSubview(fadeValueLabel)

        NSLayoutConstraint.activate([
            fadeValueLabel.topAnchor.constraint(equalTo: mainView.crossfadeSlider.bottomAnchor, constant: 4),
            fadeValueLabel.trailingAnchor.constraint(equalTo: mainView.crossfadeSlider.trailingAnchor)
        ])
    }

    

    
    private func updateFadeLabel(with value: TimeInterval) {
        fadeValueLabel.text = String(format: "%.1fs", value)
    }

    @objc private func volumeChanged(_ sender: UISlider) {
        viewModel.setMasterVolume(sender.value)
        
        // Só atualiza se o pad já estiver tocando
        if padViewModel.isPadPlaying {
            padViewModel.updateMasterVolume(sender.value)
        }
    }

    @objc private func crossfadeChanged(_ sender: UISlider) {
        viewModel.setFadeDuration(sender.value)
        updateFadeLabel(with: TimeInterval(sender.value))
    }

    @objc private func outputChanged(_ sender: UISegmentedControl) {
        viewModel.setOutputChannel(index: sender.selectedSegmentIndex)
    }
}


