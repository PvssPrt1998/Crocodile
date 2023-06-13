//
//  CategoryTableViewCell.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    public func checkmarkToggleHiddenFlag() {
        checkmark.isHidden.toggle()
    }
}
