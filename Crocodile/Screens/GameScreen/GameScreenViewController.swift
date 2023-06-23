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
    
    //MARK: - Properties
    
    //MARK: - Outlets
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var giveUpButton: UIButton!
    
    //MARK: - ViewController LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - ButtonActions
    //readyButtonAction
    //Кнопка готовности. При нажатии появляется слово и начинается таймер и кнопка меняется на кнопку "Угадано" и при нажатии появляется окно игроков
    @IBAction func readyButtonAction(_ sender: UIButton) {
        presentNewWord()
    }
    
    @IBAction func giveUpButtonAction(_ sender: UIButton) {
        guard let gameManager = gameManager else { return }
        gameManager.giveUpButtonPressed()
        wordLabel.alpha = 0.0
        giveUpButton.alpha = 0.0
        readyButton.setTitle("Готов!", for: .normal)
    }
    
    private func presentNewWord() {
        guard let gameManager = gameManager, !gameManager.chosenWords.isEmpty else { return }
        //берем слово из сета геймМенеджера и вставляем в лейбл
        let word = gameManager.setCurrentWord()
        wordLabel.text = word
        //Показываем слово (опасити 1.0)
        wordLabel.alpha = 1.0
        giveUpButton.alpha = 1.0
        readyButton.setTitle("Угадано!", for: .normal)
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
