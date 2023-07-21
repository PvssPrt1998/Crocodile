//
//  CategoryTableViewCell.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    public var cornerRadius: CGFloat = 5.0

    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    public func checkmarkToggleHiddenFlag() {
        checkmark.isHidden.toggle()
    }
    
    override func prepareForReuse() {
        checkmark.isHidden = true
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //делаем круглые углы
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
}
