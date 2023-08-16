//
//  AddPlayersViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

//MARK: - CoordinatorDelegate
public protocol AddPlayersViewControllerDelegate: AnyObject {
    func addPlayersViewControllerDidPressNext(_ viewController: AddPlayersViewController, onDismissed: (()->Void)?)
}

//MARK: - PlayerButtonActionDelegate
//Используется для передачи sender из cell во viewController
public protocol PlayerButtonActionDelegate: AnyObject {
    func playerButtonPressed(sender: UIButton)
    func isPlayerAddedNow(_ player: String)-> Bool
}

//MARK: - UIViewController (AddPlayersViewController)
public class AddPlayersViewController: UIViewController {

    //MARK: - Delegate
    public weak var delegate: AddPlayersViewControllerDelegate?
    
    //GameManager
    var gameManager: GameManager?
    
    lazy var onDismissed: ()->Void = {
        self.gameManager?.reset()
    }
    
    //MARK: - Outlets
    @IBOutlet weak var addPlayersTableView: UITableView!
    @IBOutlet weak var mainButton: MainButton!
    
    //MARK: - ViewControlletLifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupMainButton()

        addPlayersTableView.separatorStyle = .none
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addPlayersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height - mainButton.frame.origin.y, right: 0)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
    }
    
    private func setupMainButton() {
        mainButton.hide()
        mainButton.delegate = self
        mainButton.setTitle("Далее", for: .normal)
    }
    
    func setGameManager(data: AnyObject) {
        guard let data = data as? GameManager else { return }
        gameManager = data
    }
}

//MARK: - StoryboardInstantiable extension
extension AddPlayersViewController: StoryboardInstantiable {
    public class func instantiate(delegate: AddPlayersViewControllerDelegate) -> AddPlayersViewController {
        let viewController = instanceFromStoryboard()
        viewController.delegate = delegate
        return viewController
    }
}
