//
//  CustomTabBar.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 21/05/25.
//

import UIKit

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.height = 90
        return newSize
    }
}
