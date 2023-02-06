//
//  UIViewExtensions.swift
//  NewsApp
//
//  Created by Kate on 04.02.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }

    func addShadow(
        ofColor color: UIColor,
        radius: CGFloat,
        offset: CGSize = .zero,
        opacity: Float
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}
