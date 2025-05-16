//
//  MainPadViewController.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 10/04/25.
//

import UIKit
import AVFoundation

class MainPadViewController: UIViewController {
    
    private var selectedTone: Tone?
    private var selectedPadStyle: PadStyle?
    private var selectedToneButton: UIButton?
    private var selectedPadButton: UIButton?
    
    private let mainView = MainPadView()
    
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let eq = AVAudioUnitEQ(numberOfBands: 2)

    private var currentBuffer: AVAudioPCMBuffer?

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
        
        setupEQ()
        setupSliderActions()
    }

    private func setupEQ() {
        eq.globalGain = 0

        // LOW CUT (corta subgraves - deixa o som mais limpo)
        let lowCut = eq.bands[0]
        lowCut.filterType = .highPass
        lowCut.frequency = 80
        lowCut.bandwidth = 0.6
        lowCut.bypass = false

        // HIGH SHELF (suaviza agudos sem cortar tudo)
        let highCut = eq.bands[1]
        highCut.filterType = .highShelf
        highCut.frequency = 6000
        highCut.gain = 0
        highCut.bandwidth = 0.7
        highCut.bypass = false

        // Conectar nós do AVAudioEngine
        audioEngine.attach(playerNode)
        audioEngine.attach(eq)
        audioEngine.connect(playerNode, to: eq, format: nil)
        audioEngine.connect(eq, to: audioEngine.mainMixerNode, format: nil)

        try? audioEngine.start()
    }

    private func setupSliderActions() {
        mainView.highCutSlider.addTarget(self, action: #selector(highCutChanged(_:)), for: .valueChanged)
        mainView.lowCutSlider.addTarget(self, action: #selector(lowCutChanged(_:)), for: .valueChanged)
    }

    @objc private func lowCutChanged(_ sender: UISlider) {
        eq.bands[0].frequency = Float(sender.value)
    }
    
    @objc private func highCutChanged(_ sender: UISlider) {
        eq.bands[1].gain = Float(sender.value)
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
            
            mainView.updatePadPlayingBarColor(for: nil)
        } else {
            selectedPadStyle = tappedStyle
            mainView.resetButtonAppearance(selectedPadButton)
            mainView.highlightButton(sender)
            selectedPadButton = sender
            
            mainView.updatePadPlayingBarColor(for: tappedStyle)
        }

        tryPlayAudio()
    }

    private func tryPlayAudio() {
        guard let tone = selectedTone, let style = selectedPadStyle else {
            stopAudio()
            return
        }

        playPad(tone: tone, style: style)
    }

    private func stopAudio() {
        if playerNode.engine != nil && playerNode.isPlaying {
            playerNode.stop()
        }
        currentBuffer = nil
    }

    private func playPad(tone: Tone, style: PadStyle) {
        stopAudio()

        let fileName = "\(tone.fileName)_\(style.rawValue)"
        let path = "Pads/\(style.rawValue)/\(fileName).caf"
        let fileURL = Bundle.main.bundleURL.appendingPathComponent(path)

        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        do {
            let audioFile = try AVAudioFile(forReading: fileURL)
            guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                             sampleRate: audioFile.fileFormat.sampleRate,
                                             channels: audioFile.fileFormat.channelCount,
                                             interleaved: false) else { return }

            let frameCount = AVAudioFrameCount(audioFile.length)
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
            try audioFile.read(into: buffer)

            currentBuffer = buffer
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops)
            playerNode.volume = 0.1
            playerNode.play()

        } catch {
            // Silenciado
        }
    }
}

