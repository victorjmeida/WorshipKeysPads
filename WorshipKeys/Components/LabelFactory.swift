//
//  LabelFactory.swift
//  WorshipKeys
//
//  Created by João VIctir da Silva Almeida on 24/04/25.
//
import UIKit

func makeLabel(
    text: String,
    fontSize: CGFloat = 16,
    weight: UIFont.Weight = .regular,
    textColor: UIColor = .white,
    textAlignment: NSTextAlignment = .left,
    numberOfLines: Int = 1
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = textColor
    label.font = .systemFont(ofSize: fontSize, weight: weight)
    label.textAlignment = textAlignment
    label.numberOfLines = numberOfLines
    return label
}
