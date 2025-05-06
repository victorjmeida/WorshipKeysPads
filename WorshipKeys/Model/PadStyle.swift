//
//  PadStyle.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 06/05/25.
//

enum PadStyle: String, CaseIterable {
    case Base
    case Shimmer
    case Shiny
    case Warm
    case Reverse
    case Vassal

    var iconName: String {
        switch self {
        case .Base: return "music.note"
        case .Shimmer: return "sparkles"
        case .Shiny: return "sun.max"
        case .Warm: return "flame"
        case .Reverse: return "backward.end.alt"
        case .Vassal: return "waveform"
        }
    }
}
