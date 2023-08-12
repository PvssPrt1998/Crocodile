//
//  CategoryScreenViewController+CollectionViewDelegate.swift
//  Crocodile
//
//  Created by Николай Щербаков on 04.08.2023.
//

import UIKit

//MARK: - collectionViewDelegateExtension
extension CategoryScreenViewController: UICollectionViewDelegate {
    
    //didSelectItemAt indexPath
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //получаем ячейку если можем
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        //если ячейка не выделена, выделяем и наоборот
        cell.checkmarkToggleHiddenFlag()
        fetchedResultsController.object(at: indexPath).isSelected = !cell.checkmark.isHidden
        
        if isAnyCategorySelected() {
            mainButton.makeVisible()
        } else { mainButton.makeInvisible() }
    }
    
    //isAnyCategorySelected Есть ли выбранные категории
    private func isAnyCategorySelected() -> Bool {
        //проверяем содержит ли результконтроллер хоть одину выбранную категорию
        guard let result = fetchedResultsController.fetchedObjects?.contains(where: { $0.isSelected }) else { return false }
        return result
    }
    
    //Исчезновение кнопки когда начинаем скроллить
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        mainButton.makeInvisible()
    }
    
    //Появление кнопки когда палец перестал касаться экрана
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mainButton.makeVisible()
    }
    
}
