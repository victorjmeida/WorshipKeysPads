//
//  Colors.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 11/04/25.
//

import UIKit

enum Colors {

    //Background
    static let background = UIColor(hex: "#0C0C0C")
    
    //Highlights
    static let primaryHighlight = UIColor(hex: "#FF6A00")
    static let secondaryHighlight = UIColor(hex: "#F2789F")
    
    //Text
    static let primaryText = UIColor(hex: "#F2F2F2")
    
    //Controls
    static let sliderTrack = UIColor(hex: "#444444")
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#"){
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
            r = 0
            g = 0
            b = 0
        }
    
    self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
