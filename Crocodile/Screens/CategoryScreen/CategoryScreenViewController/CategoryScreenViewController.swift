//
//  ViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseStorage

//MARK: - CoordinatorDelegate
public protocol CategoryScreenViewControllerDelegate: AnyObject {
    func mainButtonDidPress(_ viewController: CategoryScreenViewController, onDismissed: (()->Void)?)
}

//MARK: - CategoryViewController
public class CategoryScreenViewController: UIViewController {
    
    //MARK: - Properties
    var gameManager: GameManager = GameManager()
    
    public weak var delegate: CategoryScreenViewControllerDelegate?

    //MARK: - IBOutlets
    @IBOutlet var mainButton: MainButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    lazy var onDismissed: ()->Void = {
        self.gameManager.reset()
        self.mainButton.hide()
    }
    
    //MARK: - ViewControllerLifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.dataManager.coreDataManager.importDataIfNeeded()
        setupMainButton()
        //importDataToFirebase()
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        categoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height - mainButton.frame.origin.y, right: 0)
    }
    
    private func setupMainButton() {
        mainButton.hide()
        mainButton.delegate = self
        mainButton.setTitle("Далее", for: .normal)
    }

    //TODO: - Need to complete method
    func setupSetFromSelectedCategories() {
        
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

//MARK: - StoryboardInstantiable extension
extension CategoryScreenViewController: StoryboardInstantiable {
    public class func instantiate(delegate: CategoryScreenViewControllerDelegate) -> CategoryScreenViewController {
        let viewController = instanceFromStoryboard()
        viewController.delegate = delegate
        return viewController
    }
}

//MARK: - Helper Methods
//TODO: - Remove this from viewController
//Import to CorData if store is empty
extension CategoryScreenViewController {
    
    func importDataToFirebase() {
        let mainFolder = "categories"
        let storage = Storage.storage()
        let reference = Database.database().reference()
        //дата и время последнего обновления
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHHmm"
        let dateString = dateFormatter.string(from: date)
        reference.child(mainFolder).child("version").setValue(dateString)
        
        //ImageBlock
        let category1title = "Memes"
        let category2title = "over18"
        
        let image = UIImage(named: category1title)
        let image1 = UIImage(named: category2title)
        
        guard let image = image, let image1 = image1 else { return }
        
        let imageData = image.pngData()
        let image1Data = image1.pngData()
        
        guard let imageData = imageData,
              let image1Data = image1Data
        else { return }
        
        let storageRef = storage.reference().child("images/\(category1title).png")
        let storage1Ref = storage.reference().child("images/\(category2title).png")
        
        storageRef.putData(imageData, metadata: nil) { (metadata,error) in
            guard let metadata = metadata else {
                print("error while uploading")
                return
            }
            
        }
        storage1Ref.putData(image1Data, metadata: nil) { (metadata,error) in
            guard let metadata = metadata else {
                print("error while uploading")
                return
            }
        }
        
        //categoriesBlock
        
        let set1 = DELETETHIS.memesWords()
        var array1: Array<String> = []
        set1.forEach { word in
            array1.append(word)
        }
        reference.child(mainFolder).child(category1title).setValue(array1)
        let set2 = DELETETHIS.over18words()
        var array2: Array<String> = []
        set2.forEach { word in
            array2.append(word)
        }
        reference.child(mainFolder).child(category2title).setValue(array2)
    }
    
    func downloadFromFirebase() {
        
    }
}
