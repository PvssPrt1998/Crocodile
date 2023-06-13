//
//  ViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

public protocol CategoryViewControllerDelegate: AnyObject {
    func categoryViewControllerDidPressNext(_ viewController: CategoryViewController)
}

public class CategoryViewController: UIViewController {
    
    //MARK: - Delegate
    public weak var delegate: CategoryViewControllerDelegate?
    
    //MARK: - Properties
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    var gameManager: GameManager?
    
    //MARK: - ViewControllerLifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        gameManager = GameManager()
        gameManager?.loadWords()
    }
    
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        delegate?.categoryViewControllerDidPressNext(self)
    }
    
    private func animateNextButton(opacity: Float) {
        UIView.animate(withDuration: 0.2) {  [] in
            self.nextButton.layer.opacity = opacity
        }
    }
}

//MARK: - collectionViewDelegateExtension
extension CategoryViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        gameManager?.selectToggle(by: indexPath.row)
        cell.checkmarkToggleHiddenFlag()
        if gameManager?.isAnySelected() == true {
            animateNextButton(opacity: 1.0)
        } else { animateNextButton(opacity: 0.0) }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animateNextButton(opacity: 0.0)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        animateNextButton(opacity: 1.0)
    }
    
}

//MARK: - collectionViewDataSourceExtension
extension CategoryViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameManager?.categories.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.categoryLabel.text = gameManager?.categories[indexPath.row].title
        return cell
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let x = view.bounds.width / 30
        let x1 = (view.bounds.width - x * 3) / 2
        
        return CGSize(width: x1, height: x1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let x = view.bounds.width / 30
        return UIEdgeInsets(top: x, left: x , bottom: x, right: x)
    }
}

//MARK: - StoryboardInstantiable extension
extension CategoryViewController: StoryboardInstantiable {
    public class func instantiate(delegate: CategoryViewControllerDelegate) -> CategoryViewController {
        let viewController = instanceFromStoryboard()
        viewController.delegate = delegate
        return viewController
    }
}
