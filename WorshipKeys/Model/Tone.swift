//
//  Tone.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 06/05/25.
//

enum Tone: String, CaseIterable {
    case C, CSharp = "C#", D, DSharp = "D#", E, F
    case FSharp = "F#", G, GSharp = "G#", A, ASharp = "A#", B

    var displayName: String {
        switch self {
        case .CSharp: return "C♯"
        case .DSharp: return "D♯"
        case .FSharp: return "F♯"
        case .GSharp: return "G♯"
        case .ASharp: return "A♯"
        default: return self.rawValue
        }
    }

    /// Nome do arquivo (sem `#`)
    var fileName: String {
        switch self {
        case .CSharp: return "CSharp"
        case .DSharp: return "DSharp"
        case .FSharp: return "FSharp"
        case .GSharp: return "GSharp"
        case .ASharp: return "ASharp"
        default: return self.rawValue
        }
    }
}
