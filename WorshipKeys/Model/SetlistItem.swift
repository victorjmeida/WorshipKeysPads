//
//  SetlistItem.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 16/05/25.
//

import Foundation

struct SetlistItem: Codable, Equatable{
    let name: String
    let tone: Tone
    let padStyle: PadStyle
    let lowCut: Float
    let highCut: Float
}
