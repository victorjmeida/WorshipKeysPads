//
//  MainPadViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 10/04/25.
//

import UIKit

class MainPadViewController: UIViewController {
    
    private let viewModel = MainPadViewModel.shared
    private let mainView = MainPadView()
    
    private var selectedToneButton: UIButton?
    private var selectedPadButton: UIButton?
    
    private var pendingPreset: SetlistItem?

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupButtonTargets(
            target: self,
            toneAction: #selector(toneTapped(_:)),
            padAction: #selector(padTapped(_:))
        )
        setupSliderActions()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let preset = pendingPreset {
            applyAndPlay(preset)
            pendingPreset = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func bindViewModel() {
        viewModel.onToneChanged = { [weak self] selectedTone in
            guard let self = self else { return }

            self.mainView.resetButtonAppearance(self.selectedToneButton)

            if let tone = selectedTone,
               let index = Tone.allCases.firstIndex(of: tone) {
                let button = self.mainView.toneButtons[index]
                self.mainView.highlightButton(button)
                self.selectedToneButton = button
            } else {
                self.selectedToneButton = nil
            }
        }

        viewModel.onPadChanged = { [weak self] selectedStyle in
            guard let self = self else { return }

            self.mainView.resetButtonAppearance(self.selectedPadButton)

            if let style = selectedStyle,
               let index = PadStyle.allCases.firstIndex(of: style) {
                let button = self.mainView.padButtons[index]
                self.mainView.highlightButton(button)
                self.mainView.updatePadPlayingBarColor(for: style)
                self.selectedPadButton = button
            } else {
                self.mainView.updatePadPlayingBarColor(for: nil)
                self.selectedPadButton = nil
            }
        }
    }

    private func setupSliderActions() {
        mainView.lowCutSlider.addTarget(self, action: #selector(lowCutChanged(_:)), for: .valueChanged)
        mainView.highCutSlider.addTarget(self, action: #selector(highCutChanged(_:)), for: .valueChanged)
    }

    // MARK: - Ações dos botões e sliders

    @objc private func toneTapped(_ sender: UIButton) {
        let tone = Tone.allCases[sender.tag]
        viewModel.selectTone(tone)
    }

    @objc private func padTapped(_ sender: UIButton) {
        let style = PadStyle.allCases[sender.tag]

        // Se o estilo for premium e o usuário não for premium, abre direto a tela de upgrade
        if style.isPremium && !PremiumAccess.isUnlocked {
            let premiumVC = PremiumViewController()
            premiumVC.modalPresentationStyle = .formSheet
            present(premiumVC, animated: true)
            return
        }

        viewModel.selectPadStyle(style)
    }
    
    func showPremiumAlert() {
        let alert = UIAlertController(
            title: "Estilo Premium",
            message: "Esse estilo faz parte do Worship Premium.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Desbloquear", style: .default) { _ in
            let premiumVC = PremiumViewController()
            premiumVC.modalPresentationStyle = .formSheet
            self.present(premiumVC, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func lowCutChanged(_ sender: UISlider) {
        viewModel.setLowCut(sender.value)
    }

    @objc private func highCutChanged(_ sender: UISlider) {
        viewModel.setHighCut(sender.value)
    }
}

extension MainPadViewController {
    func applyPreset(_ preset: SetlistItem) {
        pendingPreset = preset
    }
    
    private func applyAndPlay(_ preset: SetlistItem) {
        if let toneIndex = Tone.allCases.firstIndex(of: preset.tone) {
            let toneButton = mainView.toneButtons[toneIndex]
            toneTapped(toneButton)
        }

        if let padIndex = PadStyle.allCases.firstIndex(of: preset.padStyle) {
            let padButton = mainView.padButtons[padIndex]
            padTapped(padButton)
        }

        mainView.lowCutSlider.setValue(preset.lowCut, animated: true)
        mainView.highCutSlider.setValue(preset.highCut, animated: true)
        lowCutChanged(mainView.lowCutSlider)
        highCutChanged(mainView.highCutSlider)
    }

}

