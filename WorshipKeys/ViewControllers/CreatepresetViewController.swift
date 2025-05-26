//
//  CreatepresetViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 17/05/25.
//

import UIKit

class CreatePresetViewController: UIViewController {

    private let mainView = CreatePresetView()
    var onPresetCreated: ((SetlistItem) -> Void)?

    private var selectedTone: Tone?
    private var selectedPadStyle: PadStyle?

    private var selectedToneButton: UIButton?
    private var selectedPadButton: UIButton?

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupToneButtons()
        setupPadStyleButtons()
        mainView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Tom
    private func setupToneButtons() {
        for button in mainView.toneButtons {
            button.addTarget(self, action: #selector(toneTapped(_:)), for: .touchUpInside)
        }
    }

    @objc private func toneTapped(_ sender: UIButton) {
        let tone = Tone.allCases[sender.tag]

        if selectedTone == tone {
            selectedTone = nil
            mainView.resetButtonAppearance(selectedToneButton)
            selectedToneButton = nil
        } else {
            selectedTone = tone
            mainView.resetButtonAppearance(selectedToneButton)
            mainView.highlightButton(sender)
            selectedToneButton = sender
        }
    }

    // MARK: - Estilo (pad)
    private func setupPadStyleButtons() {
        for button in mainView.padButtons {
            button.addTarget(self, action: #selector(padStyleTapped(_:)), for: .touchUpInside)
        }
    }

    @objc private func padStyleTapped(_ sender: UIButton) {
        let style = PadStyle.allCases[sender.tag]

        if selectedPadStyle == style {
            selectedPadStyle = nil
            mainView.resetButtonAppearance(selectedPadButton)
            selectedPadButton = nil
        } else {
            selectedPadStyle = style
            mainView.resetButtonAppearance(selectedPadButton)
            mainView.highlightButton(sender)
            selectedPadButton = sender
        }
    }

    // MARK: - Salvar
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func saveTapped() {
        guard let name = mainView.nameTextField.text, !name.isEmpty else {
            showAlert(message: "Digite um nome para o preset.")
            return
        }
        guard let tone = selectedTone else {
            showAlert(message: "Selecione um tom.")
            return
        }
        guard let padStyle = selectedPadStyle else {
            showAlert(message: "Selecione um estilo de pad.")
            return
        }

        let item = SetlistItem(
            name: name,
            tone: tone,
            padStyle: padStyle,
            lowCut: mainView.lowCutSlider.value,
            highCut: mainView.highCutSlider.value
        )

        onPresetCreated?(item)
        dismiss(animated: true)
    }
}
