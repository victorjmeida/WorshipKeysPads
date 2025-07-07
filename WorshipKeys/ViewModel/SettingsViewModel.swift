//
//  SettingsViewModel.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 21/05/25.
//

import Foundation
import AVFoundation

class SettingsViewModel {

    private let fadeKey = "fadeInDuration"
    private let volumeKey = "masterVolume"

    static let shared = SettingsViewModel() // singleton

    var fadeInDuration: TimeInterval {
        get {
            let value = UserDefaults.standard.double(forKey: fadeKey)
            return (value == 0) ? 1.0 : value.clamped(to: 0.0...3.0)
        }
        set {
            let clamped = newValue.clamped(to: 0.0...3.0)
            UserDefaults.standard.setValue(clamped, forKey: fadeKey)
        }
    }

    var masterVolume: Float {
        get {
            let stored = UserDefaults.standard.float(forKey: volumeKey)
            return stored == 0 ? 0.8 : stored
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: volumeKey)
        }
    }

    init() {} // Tornado público para permitir acesso ao singleton

    func setMasterVolume(_ value: Float) {
        masterVolume = value
    }

    func setFadeDuration(_ value: Float) {
        fadeInDuration = TimeInterval(value)
    }

    func setOutputChannel(index: Int) {
        UserDefaults.standard.setValue(index, forKey: "outputPan")
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}




