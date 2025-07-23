//
//  Tone.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 06/05/25.
//

enum Tone: CaseIterable, Codable {
    case C, CSharp, D, DSharp, E, F, FSharp, G, GSharp, A, ASharp, B

    var displayName: String {
        switch self {
        case .CSharp: return "C♯"
        case .DSharp: return "D♯"
        case .FSharp: return "F♯"
        case .GSharp: return "G♯"
        case .ASharp: return "A♯"
        default: return String(describing: self)
        }
    }

    var fileName: String {
        switch self {
        case .CSharp: return "CSharp"
        case .DSharp: return "DSharp"
        case .FSharp: return "FSharp"
        case .GSharp: return "GSharp"
        case .ASharp: return "ASharp"
        default: return String(describing: self)
        }
    }
}
