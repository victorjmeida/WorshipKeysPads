//
//  Colors.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 11/04/25.
//

import UIKit

enum Colors {

    //Background
    static let background = UIColor(hexCode: "#0A0A0A") ?? .black
    static let backgroundSecond = UIColor(hexCode: "#0B0B0B") ?? .black
    
    //Highlights
    static let primaryHighlight = UIColor(hexCode: "#FF6A00") ?? .orange
    static let secondaryHighlight = UIColor(hexCode: "#F2789F") ?? .systemPink
    
    //Text
    static let primaryText = UIColor(hexCode: "#F2F2F2") ?? .white
    
    //Controls
    static let sliderTrack = UIColor(hexCode: "#444444") ?? .darkGray
}


extension UIColor {
    convenience init?(hexCode: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r, g, b: CGFloat
        switch hexSanitized.count {
        case 6:
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        default:
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIColor {
    func blended(with color: UIColor, fraction: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = r1 + (r2 - r1) * fraction
        let g = g1 + (g2 - g1) * fraction
        let b = b1 + (b2 - b1) * fraction
        let a = a1 + (a2 - a1) * fraction
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


