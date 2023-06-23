//
//  ViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit
import CoreData

//MARK: - CoordinatorDelegate
public protocol CategoryViewControllerDelegate: AnyObject {
    func categoryViewControllerDidPressNext(_ viewController: CategoryViewController)
}

//MARK: - CategoryViewController
public class CategoryViewController: UIViewController {
    
    //MARK: - Delegate
    public weak var delegate: CategoryViewControllerDelegate?
    
    //MARK: - Properties
    //IBOutlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    //CoreData properties
    //--CoreDataStack -importantString
    lazy var coreDataStack = CoreDataStack(modelName: "Crocodile")
    
    //MARK: - FetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Category.title), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: coreDataStack.managedContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        //назначаем делегатом CategoryViewController
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    //GameManager
    var gameManager: GameManager?
    
    //MARK: - ViewControllerLifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
          try fetchedResultsController.performFetch()
        } catch let error as NSError {
          print("Fetching error: \(error), \(error.userInfo)")
        }
        
        importDataIfNeeded()
        //destroyPersistentStore()
    }
    
    //RESET DATABASE
    func destroyPersistentStore() {
        guard let firstStoreURL = coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores.first?.url else {
            print("Missing first store URL - could not destroy")
            return
        }

        do {
            try coreDataStack.managedContext.persistentStoreCoordinator?.destroyPersistentStore(at: firstStoreURL, type: .sqlite)
        } catch  {
            print("Unable to destroy persistent store: \(error) - \(error.localizedDescription)")
       }
    }
    
    //NextButtonAction
    @IBAction func nextButtonAction(_ sender: UIButton) {
        //Передает делегату (делегатом является координатор) себя в качестве параметра
        delegate?.categoryViewControllerDidPressNext(self)
    }
    
    //анимация появления кнопки
    private func animateNextButton(opacity: Float) {
        UIView.animate(withDuration: 0.2) {  [] in
            self.nextButton.layer.opacity = opacity
        }
    }
}

//MARK: - collectionViewDelegateExtension
extension CategoryViewController: UICollectionViewDelegate {
    
    //didSelectItemAt indexPath
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //получаем ячейку если можем
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        //меняем категорию на выбранную или наоборот
        guard let title = cell.categoryLabel.text, let gameManager = gameManager else { return }
        gameManager.chosenCategories.didSelectCategory(title: title)
        //TODO: - ПРОВЕРИТЬ НА СБРОС добавить в cell класс функцию prepare for reuse ЯЧЕЕК!---------------------------------------------------------------------------------------------------------------------------
        cell.checkmarkToggleHiddenFlag()
        if gameManager.chosenCategories.isAnyCategorySelected() {
            animateNextButton(opacity: 1.0)
        } else { animateNextButton(opacity: 0.0) }
    }
    
    //Исчезновение кнопки когда начинаем скроллить
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animateNextButton(opacity: 0.0)
    }
    
    //Появление кнопки когда палец перестал касаться экрана
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        animateNextButton(opacity: 1.0)
    }
    
}

//MARK: - collectionViewDataSourceExtension
extension CategoryViewController: UICollectionViewDataSource {
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
        configure(cell: cell, for: indexPath)
        return cell
    }
    
    //configure cell
    private func configure(cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? CategoryCollectionViewCell else { return }
        let category = fetchedResultsController.object(at: indexPath)
        cell.categoryLabel.text = category.title
        guard let image = UIImage(data: category.image) else { return }
        cell.categoryImageView.image = image
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //ширина экрана / 30
        let totalWidth = view.bounds.width
        let numberOfCellsPerLine: CGFloat = 3
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

//MARK: - FetchedResultsControllerDelegate
extension CategoryViewController: NSFetchedResultsControllerDelegate {

}

//MARK: - StoryboardInstantiable extension
extension CategoryViewController: StoryboardInstantiable {
    public class func instantiate(delegate: CategoryViewControllerDelegate) -> CategoryViewController {
        let viewController = instanceFromStoryboard()
        viewController.delegate = delegate
        return viewController
    }
}

//MARK: - Helper Methods
//Import to CorData if store is empty
extension CategoryViewController {
    
    func importDataIfNeeded() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let count = try? coreDataStack.managedContext.count(for: fetchRequest)
        
        guard let categoriesCount = count, categoriesCount == 0 else { return }
        importData()
    }
    
    func importData() {
        let category = Category(context: coreDataStack.managedContext)
        let image = UIImage(named: "Memes")
        let image1 = UIImage(named: "over18")
        //добавляем мемы категорию
        category.title = "Memes"
        guard let image = image, let image1 = image1 else { return }
        guard let image = image.pngData(), let image1 = image1.pngData() else { return }
        category.image = image
        coreDataStack.saveContext()
        //добавляем set слов
        DELETETHIS.memesWords().forEach { memesWord in
            let word = Word(context: coreDataStack.managedContext)
            word.category = category
            word.word = memesWord
        }
        //добавляем 18+ категорию
        let category1 = Category(context: coreDataStack.managedContext)
        category1.title = "Over18"
        category1.image = image1
        //добавляем set слов
        DELETETHIS.over18words().forEach { memesWord in
            let word = Word(context: coreDataStack.managedContext)
            word.category = category1
            word.word = memesWord
        }
        
        coreDataStack.saveContext()
    }
}
