//
//  UIButton + InnerShadow.swift
//  Crocodile
//
//  Created by Николай Щербаков on 21.07.2023.
//

import UIKit

extension UIButton {
    public func innerShadow(backgroundColor: CGColor) {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
        layer.masksToBounds = true
        layer.borderWidth = 1.5
        layer.borderColor = backgroundColor
        layer.cornerRadius = bounds.width / 20
    }
}
