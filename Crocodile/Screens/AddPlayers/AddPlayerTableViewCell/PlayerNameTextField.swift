//
//  PlayerNameTextField.swift
//  Crocodile
//
//  Created by Николай Щербаков on 14.08.2023.
//

import UIKit

class PlayerNameTextField: UITextField {
    
    //MARK: - Properties
    let innerShadow = CALayer()
    
    //MARK: - Methods
    //call this method in awakeFromNib of superclass
    func setupLayers() {
        setupLayer()
        setupInnerShadowLayer()
        self.layer.addSublayer(innerShadow)
    }
    
    //call this method in superclass when sizes finally calculated
    func setupLayers(with borderWidth: CGFloat, and cornerRadius: CGFloat) {
        setupLayer(with: borderWidth, and: cornerRadius)
        setupInnerShadowLayer(with: borderWidth, and: cornerRadius)
    }
    
    //MARK: - Private methods
    //основной слой
    private func setupLayer() {
        self.layer.opacity = 0.6
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.tintColor = .gray
    }
    
    //основной слой, когда известны размеры
    private func setupLayer(with borderWidth: CGFloat, and cornerRadius: CGFloat) {
        setupTextFieldHorizontalPadding(with: borderWidth, and: cornerRadius)
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    //Слой внутренней тени
    private func setupInnerShadowLayer() {
        innerShadow.masksToBounds = true
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 3, height: 3)
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 3
    }
    
    //Слой внутренней тени когда известны размеры
    private func setupInnerShadowLayer(with borderWidth: CGFloat, and cornerRadius: CGFloat) {
        var innerShadowLayer: CALayer? = nil
        
        //находим слой innerShadow среди добавленных слоев
        let _ = self.layer.sublayers?.map({ layer in
            if layer === self.innerShadow {
                innerShadowLayer = layer
            }
        })
        
        guard let innerShadowLayer = innerShadowLayer else { return }
        innerShadowLayer.frame = self.bounds
        
        innerShadowLayer.shadowPath = calculateShadowPath(with: borderWidth, and: cornerRadius)
    }
    
    private func calculateShadowPath(with borderWidth: CGFloat, and cornerRadius: CGFloat) -> CGPath {
        let dx: CGFloat = -borderWidth - 1
        let dy: CGFloat = -borderWidth - 1
        let path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: dx, dy: dy), cornerRadius: cornerRadius + dy)
        let cutout = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius + dy).reversing()
        
        path.append(cutout)
        return path.cgPath
    }
    
    
    //Content Insets
    private func setupTextFieldHorizontalPadding(with borderWidth: CGFloat, and cornerRadius: CGFloat) {
        let textFieldInset: CGFloat = (borderWidth * 2) + (cornerRadius / 2)
        self.setLeftPaddingPoints(textFieldInset)
        self.setRightPaddingPoints(textFieldInset)
        
    }
    
    private func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    private func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }

}
