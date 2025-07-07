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
    private var currentPlayingFileURL: URL?

    private var fadeTimer: Timer?

    private init() {
        setupAudioEngine()
    }

    // MARK: - Setup Engine
    private func setupAudioEngine() {
        eq.globalGain = 0

        let lowCut = eq.bands[0]
        lowCut.filterType = .highPass
        lowCut.frequency = 80
        lowCut.bandwidth = 0.6
        lowCut.bypass = false

        let highCut = eq.bands[1]
        highCut.filterType = .lowPass
        highCut.frequency = 20000
        highCut.bandwidth = 0.5
        highCut.bypass = false

        audioEngine.attach(playerNode)
        audioEngine.attach(eq)

        let outputFormat = audioEngine.outputNode.inputFormat(forBus: 0)
        audioEngine.connect(playerNode, to: eq, format: outputFormat)
        audioEngine.connect(eq, to: audioEngine.mainMixerNode, format: outputFormat)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            try audioEngine.start()
            print("✅ Audio engine started")
        } catch {
                print("❌ Falha ao iniciar audio engine: \(error.localizedDescription)")
        }
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

    func tryPlayAudio() {
        guard let tone = selectedTone, let style = selectedPadStyle else {
            stopAudio()
            return
        }

        playPad(tone: tone, style: style)
    }

    private func stopAudio() {
        if playerNode.isPlaying {
            playerNode.stop()
            onAudioStopped?()
        }
    }

    private func playPad(tone: Tone, style: PadStyle) {
        let fileName = "\(tone.fileName)_\(style.rawValue)"
        let path = "Pads/\(style.rawValue)/\(fileName).caf"
        let fileURL = Bundle.main.bundleURL.appendingPathComponent(path)
        currentPlayingFileURL = fileURL

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("⚠️ Áudio não encontrado: \(fileName)")
            return
        }

        do {
            let audioFile = try AVAudioFile(forReading: fileURL)
            let inputFormat = audioFile.processingFormat
            let outputFormat = audioEngine.mainMixerNode.outputFormat(forBus: 0)

            let converter = AVAudioConverter(from: inputFormat, to: outputFormat)

            let inputBuffer = AVAudioPCMBuffer(pcmFormat: inputFormat, frameCapacity: AVAudioFrameCount(audioFile.length))!
            try audioFile.read(into: inputBuffer)

            let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: inputBuffer.frameCapacity)!

            var error: NSError?
            let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                outStatus.pointee = .haveData
                return inputBuffer
            }

            converter?.convert(to: convertedBuffer, error: &error, withInputFrom: inputBlock)

            if let error = error {
                print("❌ Erro na conversão: \(error.localizedDescription)")
                return
            }

            playWithFade(to: convertedBuffer)
            onAudioStarted?()

        } catch {
            print("❌ Erro ao carregar áudio: \(error.localizedDescription)")
        }
    }

    private func playWithFade(to newBuffer: AVAudioPCMBuffer) {
        fadeTimer?.invalidate()

        let fadeDuration = SettingsViewModel.shared.fadeInDuration
        let targetVolume = SettingsViewModel.shared.masterVolume
        let fadeSteps = 30
        let stepTime = fadeDuration / Double(fadeSteps)
        let volumeStep = targetVolume / Float(fadeSteps)
        var currentStep = 0

        if playerNode.isPlaying && fadeDuration > 0 {
            fadeTimer = Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { [weak self] timer in
                guard let self = self else { return timer.invalidate() }
                currentStep += 1
                let newVol = targetVolume - Float(currentStep) * volumeStep
                self.playerNode.volume = max(0, newVol)

                if currentStep >= fadeSteps {
                    timer.invalidate()
                    self.fadeTimer = nil
                    self.startBuffer(newBuffer, volume: 0, fadeIn: true)
                }
            }
            RunLoop.main.add(fadeTimer!, forMode: .common)
        } else {
            startBuffer(newBuffer, volume: fadeDuration > 0 ? 0 : targetVolume, fadeIn: fadeDuration > 0)
        }
    }

    private func startBuffer(_ buffer: AVAudioPCMBuffer, volume: Float, fadeIn: Bool) {
        let targetVolume = SettingsViewModel.shared.masterVolume
        let fadeDuration = SettingsViewModel.shared.fadeInDuration
        let fadeSteps = 30
        let stepTime = fadeDuration / Double(fadeSteps)
        let volumeStep = targetVolume / Float(fadeSteps)
        var currentStep = 0

        playerNode.stop()
        playerNode.volume = 0
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops)
        playerNode.play()

        if fadeIn {
            fadeTimer = Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { [weak self] timer in
                guard let self = self else { return timer.invalidate() }
                currentStep += 1
                self.playerNode.volume = Float(currentStep) * volumeStep

                if currentStep >= fadeSteps {
                    timer.invalidate()
                    self.fadeTimer = nil
                }
            }
            RunLoop.main.add(fadeTimer!, forMode: .common)
        } else {
            // Se não for fade, coloque o volume só depois do play para evitar pop
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.playerNode.volume = targetVolume
            }
        }
    }

    func reactivateAudioIfNeeded() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            if !audioEngine.isRunning {
                try audioEngine.start()
                print("🔄 AudioEngine restarted")
            }
        } catch {
            print("❌ Falha ao reativar audio: \(error.localizedDescription)")
        }
        // Tenta tocar o áudio novamente (se houver seleção)
        tryPlayAudio()
    }

    func updateMasterVolume(_ volume: Float) {
        playerNode.volume = volume
    }

    func setLowCut(_ frequency: Float) {
        eq.bands[0].frequency = frequency
    }

    func setHighCut(_ frequency: Float) {
        eq.bands[1].frequency = frequency
    }


    var isPadPlaying: Bool {
        return playerNode.isPlaying
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
