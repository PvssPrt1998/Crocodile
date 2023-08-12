//
//  ViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit
import CoreData

//MARK: - CoordinatorDelegate
public protocol CategoryScreenViewControllerDelegate: AnyObject {
    func mainButtonDidPress(_ viewController: CategoryScreenViewController, onDismissed: (()->Void)?)
}

//MARK: - CategoryViewController
public class CategoryScreenViewController: UIViewController {
    
    //MARK: - Properties
    private let modelName: String = "Crocodile"
    var gameManager: GameManager = GameManager()
    
    //MARK: - Delegate
    public weak var delegate: CategoryScreenViewControllerDelegate?

    //MARK: - IBOutlets
    @IBOutlet var mainButton: MainButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    lazy var onDismissed: ()->Void = {
        self.gameManager.reset()
        self.mainButton.hide()
    }
    
    //MARK: - CoreData
    //CoreDataStack
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
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
    
    //MARK: - ViewControllerLifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        performFecth()
        
        importDataIfNeeded()
        
        mainButton.hide()
        mainButton.delegate = self
        //destroyPersistentStore()
    }
    
    private func performFecth() {
        do {
          try fetchedResultsController.performFetch()
        } catch let error as NSError {
          print("Fetching error: \(error), \(error.userInfo)")
        }
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

    func setupSetFromSelectedCategories() {
        //проходим через все категории
        fetchedResultsController.fetchedObjects?.forEach({ category in
            //смотрим есть ли выбранные
            if category.isSelected {
                //получаем сет элементов NSSet.Element для выбранной категории
                guard let set = category.words else { return }
                //каждый NSSet.Element приводим к типу word и закидываем word в геймменеджер сет
                set.forEach { item in
                    guard let item = item as? Word, let word = item.word else { return }
                    gameManager.wordManager.addWord(word)
                }
            }
        })
    }
    
    //сбрасывает элементы коллекшн вью к значениям по умолчанию
    func resetAllElementsCollectionView() {
        loopThroughEachCellWith { cell, _ in
            //снимается выделение с каждого cell
            cell.prepareForReuse()
        }
    }
    
    //метод в котором для каждой ячейки выполняется какое-нибудь действие
    private func loopThroughEachCellWith(action: (CategoryCollectionViewCell, IndexPath)->Void) {
        //получаем количество ячеек коллекшн вью (= количеству отображенных категорий)
        let cellsCount = categoryCollectionView.numberOfItems(inSection: 0)
        //проходим по всем объектам коллекшн вью
        for index in 0..<cellsCount {
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = categoryCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
            action(cell,indexPath)
        }
    }
}

//MARK: - FetchedResultsControllerDelegate
extension CategoryScreenViewController: NSFetchedResultsControllerDelegate {

}

//MARK: - StoryboardInstantiable extension
extension CategoryScreenViewController: StoryboardInstantiable {
    public class func instantiate(delegate: CategoryScreenViewControllerDelegate) -> CategoryScreenViewController {
        let viewController = instanceFromStoryboard()
        viewController.delegate = delegate
        return viewController
    }
}

//MARK: - Helper Methods
//Import to CorData if store is empty
extension CategoryScreenViewController {
    
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
