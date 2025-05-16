//
//  PadStyle.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 06/05/25.
//
import UIKit

enum PadStyle: String, CaseIterable {
    case Base
    case Shimmer
    case Shiny
    case Warm
    case Reverse
    case Vassal
    
    var color: UIColor {
        switch self {
        case .Base: return UIColor(hex: "#7C3AED")
        case .Shimmer: return UIColor(hex: "#FACC15")
        case .Shiny: return UIColor(hex: "#38BDF8")
        case .Warm: return UIColor(hex: "#A62F03")
        case .Reverse: return UIColor(hex: "#9512A6")
        case .Vassal: return UIColor(hex: "#077322")
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

