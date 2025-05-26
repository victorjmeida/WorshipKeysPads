//
//  MainPadViewModel.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 17/05/25.
//

import Foundation
import AVFoundation

class MainPadViewModel {

    static let shared = MainPadViewModel()

    // MARK: - Callbacks para a ViewController
    var onAudioStarted: (() -> Void)?
    var onAudioStopped: (() -> Void)?
    var onToneChanged: ((Tone?) -> Void)?
    var onPadChanged: ((PadStyle?) -> Void)?

    // MARK: - Estado atual
    private(set) var selectedTone: Tone?
    private(set) var selectedPadStyle: PadStyle?

    // MARK: - Áudio
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let eq = AVAudioUnitEQ(numberOfBands: 2)
    private var currentBuffer: AVAudioPCMBuffer?
    private var fadeTimer: Timer?

    // MARK: - Inicialização
    private init() {
        setupAudioEngine()
    }

    // MARK: - Seleções
    func selectTone(_ tone: Tone) {
        selectedTone = (tone == selectedTone) ? nil : tone
        onToneChanged?(selectedTone)
        tryPlayAudio()
    }

    func selectPadStyle(_ style: PadStyle) {
        selectedPadStyle = (style == selectedPadStyle) ? nil : style
        onPadChanged?(selectedPadStyle)
        tryPlayAudio()
    }

    // MARK: - EQ
    func setLowCut(_ frequency: Float) {
        eq.bands[0].frequency = frequency
    }

    func setHighCut(_ gain: Float) {
        eq.bands[1].gain = gain
    }

    // MARK: - Atualização direta de volume
    func updateMasterVolume() {
        playerNode.volume = SettingsViewModel.shared.masterVolume
    }

    // MARK: - Áudio Setup
    private func setupAudioEngine() {
        eq.globalGain = 0

        let lowCut = eq.bands[0]
        lowCut.filterType = .highPass
        lowCut.frequency = 80
        lowCut.bandwidth = 0.6
        lowCut.bypass = false

        let highCut = eq.bands[1]
        highCut.filterType = .highShelf
        highCut.frequency = 6000
        highCut.gain = 0
        highCut.bandwidth = 0.7
        highCut.bypass = false

        audioEngine.attach(playerNode)
        audioEngine.attach(eq)
        audioEngine.connect(playerNode, to: eq, format: nil)
        audioEngine.connect(eq, to: audioEngine.mainMixerNode, format: nil)

        try? audioEngine.start()
    }

    // MARK: - Reproduzir / Parar áudio
    func tryPlayAudio() {
        guard let tone = selectedTone, let style = selectedPadStyle else {
            stopAudio()
            return
        }

        playPad(tone: tone, style: style)
    }

    private func stopAudio() {
        if playerNode.engine != nil && playerNode.isPlaying {
            playerNode.stop()
            onAudioStopped?()
        }
        currentBuffer = nil
    }

    private func fadeInPlayerVolume(to targetVolume: Float, duration: TimeInterval) {
        fadeTimer?.invalidate()

        let steps = 30
        let stepTime = duration / Double(steps)
        let volumeIncrement = targetVolume / Float(steps)
        var currentStep = 0

        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            currentStep += 1
            let newVolume = volumeIncrement * Float(currentStep)
            self.playerNode.volume = newVolume

            if currentStep >= steps {
                timer.invalidate()
                self.fadeTimer = nil
            }
        }

        RunLoop.current.add(fadeTimer!, forMode: .common)
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
            playerNode.volume = 0
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops)
            playerNode.play()

            let targetVolume = SettingsViewModel.shared.masterVolume
            let fadeDuration = SettingsViewModel.shared.fadeInDuration
            fadeInPlayerVolume(to: targetVolume, duration: fadeDuration)
            onAudioStarted?()

        } catch {
            // erro silenciado
        }
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

