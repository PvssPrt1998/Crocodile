//
//  GameViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

//MARK: - CoordinatorDelegate
public protocol GameScreenViewControllerDelegate: AnyObject {
    func GameViewControllerDidPressNext(_ viewController: GameScreenViewController)
}

public final class GameScreenViewController: UIViewController {
    
    //GameManager
    var gameManager: GameManager?
    
    //Delegate
    public weak var delegate: GameScreenViewControllerDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    
    //MARK: - ViewController LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        gameManager?.splitSets()
    }
    
    //MARK: - ButtonActions
    //readyButtonAction
    @IBAction func readyButtonAction(_ sender: UIButton) {
        guard let gameManager = gameManager, !gameManager.chosenWords.isEmpty else { return }
        //берем слово из сета геймМенеджера и вставляем в лейбл
        let word = gameManager.chosenWords.removeFirst()
        wordLabel.text = word
        //Показываем слово (опасити 1.0)
        wordLabel.alpha = 1.0
    }
    
    @IBAction func giveUpButtonAction(_ sender: UIButton) {
        
    }
    
    
    
}

//MARK: - StoryboardInstantiable extension
extension GameScreenViewController: StoryboardInstantiable {
    public class func instantiate(delegate: GameScreenViewControllerDelegate) -> GameScreenViewController {
        let viewController = instanceFromStoryboard()
        viewController.delegate = delegate
        return viewController
    }
}
