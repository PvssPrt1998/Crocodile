//
//  CategoryScreenViewController+CollectionViewDataSource.swift
//  Crocodile
//
//  Created by Николай Щербаков on 04.08.2023.
//

import UIKit

//MARK: - collectionViewDataSourceExtension
extension CategoryScreenViewController: UICollectionViewDataSource {
    //Количество секций
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        
        return sections.count
    }
    
    //Количество ячеек в секции
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    //CellForItemAt Конфигурируем ячейки
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        configure(cell, for: indexPath)
        return cell
    }
    
    //configure cell
    private func configure(_ cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? CategoryCollectionViewCell else { return }
        let category = fetchedResultsController.object(at: indexPath)
        cell.categoryLabel.text = category.title
        guard let imageData = category.image, let image = UIImage(data: imageData) else { return }
        cell.categoryImageView.image = image
    }
}
