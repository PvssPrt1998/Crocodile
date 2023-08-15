//
//  PlayerNameTextField.swift
//  Crocodile
//
//  Created by Николай Щербаков on 14.08.2023.
//

import UIKit

class PlayerNameTextField: UITextField {
    
    let innerShadow = CALayer()
    public var sizeForCalculateLayout: CGFloat = 0 {
        didSet {
            cornerRadius = sizeForCalculateLayout / 30
        }
    }
    var cornerRadius: CGFloat = 0
    var borderWidth: CGFloat = 2
    
    func addLayer() {
        let textFieldInset: CGFloat = (borderWidth * 2) + (cornerRadius / 2)
        innerShadow.masksToBounds = true
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 0)
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 3
        self.layer.addSublayer(innerShadow)
        
        self.layer.opacity = 0.6
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        
        self.setLeftPaddingPoints(textFieldInset)
        self.setRightPaddingPoints(textFieldInset)
        self.tintColor = .gray
    }
    
    
    
    func setupLayer() {
        var innerShadowLayer: CALayer? = nil
        
        self.layer.sublayers?.map({ layer in
            if layer === self.innerShadow {
                innerShadowLayer = layer
            }
        })
        guard let innerShadowLayer = innerShadowLayer else { return }
        
//        let cornerRadius = sizeForCalculateLayout / 30
        //let borderWidth: CGFloat = 2
//        let textFieldInset: CGFloat = (borderWidth * 2) + (cornerRadius / 2)
        
        innerShadowLayer.frame = self.bounds

        let radius = cornerRadius
        let dx: CGFloat = -borderWidth
        let dy: CGFloat = -borderWidth
        let path = UIBezierPath(roundedRect: layer.bounds.insetBy(dx: dx, dy: dy), cornerRadius: radius + dy)
        let cutout = UIBezierPath(roundedRect: layer.bounds, cornerRadius:radius).reversing()

        path.append(cutout)
        //print(self.layer.sublayers?.count)
        
        innerShadowLayer.shadowPath = path.cgPath
//        innerShadow.masksToBounds = true
//        innerShadow.shadowColor = UIColor.black.cgColor
//        innerShadow.shadowOffset = CGSize(width: 0, height: 0)
//        innerShadow.shadowOpacity = 1
//        innerShadow.shadowRadius = 3
        //self.layer.addSublayer(innerShadow)
        
        //print(self.layer.sublayers?.count)
//
//        self.layer.opacity = 0.6
//        self.layer.cornerRadius = cornerRadius
//        self.layer.borderWidth = borderWidth
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.masksToBounds = true
//
//        self.setLeftPaddingPoints(textFieldInset)
//        self.setRightPaddingPoints(textFieldInset)
//        self.tintColor = .gray
    }
    

}
