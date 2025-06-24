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
    
    // Para garantir que o preset só será aplicado quando a tela estiver ativa
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyPresetFromNotification(_:)),
            name: .setlistPresetSelected,
            object: nil
        )
        setupSliderActions()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Aplica o preset pendente (caso venha de outra tela)
        if let preset = pendingPreset {
            applyAndPlay(preset)
            pendingPreset = nil
        }
    }

    // MARK: - Bindings
    
    private func bindViewModel() {
        // Atualização visual dos botões de tom
        viewModel.onToneChanged = { [weak self] selectedTone in
            guard let self = self else { return }
            self.mainView.toneButtons.forEach { self.mainView.resetToneButtonAppearance($0) }
            if let tone = selectedTone,
               let index = Tone.allCases.firstIndex(of: tone) {
                let button = self.mainView.toneButtons[index]
                self.mainView.highlightButton(button)
                self.selectedToneButton = button
            } else {
                self.selectedToneButton = nil
            }
        }
        // Atualização visual dos botões de pad
        viewModel.onPadChanged = { [weak self] selectedStyle in
            guard let self = self else { return }
            self.mainView.padButtons.forEach { self.mainView.resetPadButtonAppearance($0) }
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
        if style.isPremium && !PremiumAccess.isUnlocked {
            showPremiumAlert()
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
    
    // MARK: - Notificação de Preset Selecionado

    @objc private func applyPresetFromNotification(_ notification: Notification) {
        print("MainPad recebeu notificação!")
        guard let preset = notification.object as? SetlistItem else { return }
        print("Preset recebido:", preset.name)
        // Se a tela está visível, aplica na hora; se não, marca para aplicar depois
        if isViewLoaded && view.window != nil {
            applyAndPlay(preset)
        } else {
            pendingPreset = preset
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Aplicar Preset

extension MainPadViewController {
    func applyPreset(_ preset: SetlistItem) {
        // Se a tela está visível, aplica imediatamente; se não, agenda
        if isViewLoaded && view.window != nil {
            applyAndPlay(preset)
        } else {
            pendingPreset = preset
        }
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


