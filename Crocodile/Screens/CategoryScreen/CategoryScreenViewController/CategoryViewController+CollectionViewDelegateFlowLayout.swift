//
//  CategoryViewController+CollectionViewDelegateFlowLayout.swift
//  Crocodile
//
//  Created by Николай Щербаков on 04.08.2023.
//

import UIKit

//MARK: - CollectionViewDelegateFlowLayout
extension CategoryScreenViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //ширина экрана / 30
        let totalWidth = view.bounds.width
        let numberOfCellsPerLine: CGFloat = 2
        let width = (totalWidth - (totalWidth / 30) * (numberOfCellsPerLine + 1)) / numberOfCellsPerLine
        //высота экрана
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let x = view.bounds.width / 30
        return UIEdgeInsets(top: x, left: x , bottom: x, right: x)
    }
}
