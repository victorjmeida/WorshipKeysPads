//
//  MainPadViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 10/04/25.
//

import AVFoundation
import UIKit

class MainPadViewController: UIViewController {
    
    private var selectedTone: Tone?
    private var selectedPadStyle: PadStyle?
    private var audioPlayer: AVAudioPlayer?
    private var selectedToneButton: UIButton?
    private var selectedPadButton: UIButton?
    
    //Conectando a ViewController
    private let mainView = MainPadView()
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupButtonTargets(target: self,
        toneAction: #selector(toneTapped(_:)),
        padAction: #selector(padTapped(_:)))
    }
    
    @objc private func toneTapped(_ sender: UIButton) {
            let tappedTone = Tone.allCases[sender.tag]

            if selectedTone == tappedTone {
                selectedTone = nil
                mainView.resetButtonAppearance(selectedToneButton)
                selectedToneButton = nil
                stopAudio()
            } else {
                selectedTone = tappedTone
                mainView.resetButtonAppearance(selectedToneButton)
                mainView.highlightButton(sender)
                selectedToneButton = sender
            }

            tryPlayAudio()
        }

        @objc private func padTapped(_ sender: UIButton) {
            let tappedStyle = PadStyle.allCases[sender.tag]

            if selectedPadStyle == tappedStyle {
                selectedPadStyle = nil
                mainView.resetButtonAppearance(selectedPadButton)
                selectedPadButton = nil
                stopAudio()
            } else {
                selectedPadStyle = tappedStyle
                mainView.resetButtonAppearance(selectedPadButton)
                mainView.highlightButton(sender)
                selectedPadButton = sender
            }

            tryPlayAudio()
        }
    
    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
        
    private func tryPlayAudio() {
        guard let tone = selectedTone, let style = selectedPadStyle else { return }
        playPad(tone: tone, style: style)
    }

    private func playPad(tone: Tone, style: PadStyle) {
        let fileName = "\(tone.fileName)_\(style.rawValue)"
        let pathInBundle = "Pads/\(style.rawValue)/\(fileName).caf"
        let fileURL = Bundle.main.bundleURL.appendingPathComponent(pathInBundle)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            // Silenciado
        }
    }
}
