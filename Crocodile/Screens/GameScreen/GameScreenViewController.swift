//
//  GameViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

//MARK: - CoordinatorDelegate
public protocol GameScreenViewControllerDelegate: AnyObject {
    func GameViewControllerDidPressRatingButton(_ viewController: GameScreenViewController)
    func GameViewControllerDidPressGuessed(_ viewController: GameScreenViewController)
}

public final class GameScreenViewController: UIViewController {
    
    //GameManager
    var gameManager: GameManager?
    
    //Delegate
    //Делегатом выступает координатор данного контроллера
    public weak var delegate: GameScreenViewControllerDelegate?
    
    //TODO: - вывести геймСтейт в геймменеджер
    enum GameState {
        case inProgress
        case waiting
    }
    
    //TODO: - свойство геймСтейт тоже вынести в геймменеджер
    var gameState: GameState = .waiting
    
    //MARK: - Properties
    
    //MARK: - Outlets
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var giveUpButton: UIButton!
    
    //MARK: - ViewController LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configMiddleBarButton()
        print(navigationController?.navigationBar.frame.height ?? 0)
    }
    
    //MARK: - Configure views
    //Кнопка в titleView navigationBar
    private func configMiddleBarButton() {
        let titleButton =  UIButton(type: .custom)
        let viewHeight = view.bounds.height
        let viewWidth = view.bounds.width
        titleButton.frame = CGRect(x: 0, y: 0, width: viewWidth / 7, height: viewHeight / 25)
        titleButton.backgroundColor = .clear
        titleButton.setTitle("Рейтинг", for: .normal)
        titleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        titleButton.tintColor = .black
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        titleButton.addTarget(self, action: #selector(scoreCenterBarButtonAction), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
    
    //MARK: - ButtonActions
    //readyButtonAction
    //Кнопка готовности. При нажатии появляется слово и начинается таймер и кнопка меняется на кнопку "Угадано" и при нажатии появляется окно игроков
    @IBAction func readyButtonAction(_ sender: UIButton) {
        if gameState == .waiting {
            presentNewWord()
        } else {
            presentIncreaseScoreScreenViewController()
        }
        gameStateToggle()
    }
    
    //Нажата кнопка сдаться
    @IBAction func giveUpButtonAction(_ sender: UIButton) {
        guard let gameManager = gameManager else { return }
        gameManager.giveUpButtonPressed()
        wordLabel.alpha = 0.0
        giveUpButton.alpha = 0.0
        readyButton.setTitle("Готов!", for: .normal)
    }
    
    @objc
    func scoreCenterBarButtonAction() {
        delegate?.GameViewControllerDidPressRatingButton(self)
    }
    
    
    //Отобразить нвоое слово
    private func presentNewWord() {
        //Проверяем остались ли вообще слова в сете. Если не остались, то все слова угаданы и надо вывести пользователю
        //сообщение с предложением повторить или попробовать другие категории
        guard let gameManager = gameManager, !gameManager.chosenWords.isEmpty else { return }
        //берем слово из сета геймМенеджера и вставляем в лейбл
        let word = gameManager.setCurrentWord()
        wordLabel.text = word
        //Показываем слово (опасити 1.0)
        wordLabel.alpha = 1.0
        giveUpButton.alpha = 1.0
        readyButton.setTitle("Угадано!", for: .normal)
    }
    
    //переключает состояние игры на ожидание когда игрок будет готов показывать, либо наоборот
    private func gameStateToggle() {
        if gameState == .inProgress {
            gameState = .waiting
        } else {
            gameState = .inProgress
        }
    }
    
    //Срабатывает если кто-то угадал слово и показывающий игрок нажал на кнопку "Угадано!"
    //Открывает IncreasePlayerScoreScreenViewController где показывающий выбирает отгадавшего
    private func presentIncreaseScoreScreenViewController() {
        delegate?.GameViewControllerDidPressGuessed(self)
        print("presentIncreaseScoreScreenViewController end")
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
