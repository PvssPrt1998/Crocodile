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
    func GameViewControllerDidPressGuessed(_ viewController: GameScreenViewController, onDismissed: (()->Void)?)
}

public final class GameScreenViewController: UIViewController {
    
    //MARK: - Properties
    var gameManager: GameManager?

    //Делегатом выступает координатор данного контроллера
    public weak var delegate: GameScreenViewControllerDelegate?
    
    private lazy var onDismissed: ()->Void = {
        guard let navigationTitleButton = self.navigationItem.titleView as? UIButton  else { return }
        navigationTitleButton.setTitle("Рейтинг", for: .normal)
        navigationTitleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
    
    //TODO: - вывести геймСтейт в геймменеджер
    enum GameState {
        case inProgress
        case waiting
    }
    
    //TODO: - свойство геймСтейт тоже вынести в геймменеджер
    var gameState: GameState = .waiting {
        willSet {
            if newValue == .waiting {
                prepareViewsForWaitingState()
            } else {
                prepareViewsForInProgressState()
            }
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var gameContainerView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var giveUpButton: UIButton!
    @IBOutlet weak var showingPlayerLabel: UILabel!
    @IBOutlet weak var backgroundViewForButton: UIView!
    
    //MARK: - ViewController LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfigs()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //фишка с внутренней тенью. Если сделать борт вокруг вьюшки и тень, то тень провалится внутрь при условии
        //что backgroundColor = clear
        readyButton.innerShadow(backgroundColor: UIColor(rgb: 0x00DF08).cgColor)
        backgroundViewForButton.layer.cornerRadius = readyButton.layer.cornerRadius
        gameContainerView.layer.cornerRadius = backgroundViewForButton.layer.cornerRadius
    }
    
    //MARK: - Configure views methods
    //задает нужный текст для лейблов и кнопок при загрузке
    private func setupViewConfigs() {
        configMiddleBarButton()
        prepareViewsForWaitingState()
    }
    
    //готовит вьюшки для состояния ожидания готовности игрока
    private func prepareViewsForWaitingState() {
        guard let gameManager = gameManager else { return }
        let showingPlayerLabelText = gameManager.playerManager.currentPlayer?.name ?? ""
        showingPlayerLabel.text = "Показывает игрок: \(showingPlayerLabelText)"
        //отображаем лейбл с именем показывающего
        showingPlayerLabel.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.showingPlayerLabel.layer.opacity = 1.0
        }
        
        readyButton.setTitle("Готов!", for: .normal)
    }
    
    //готовит вьюшки для состояния "игра в процессе"
    private func prepareViewsForInProgressState() {
        UIView.animate(withDuration: 0.2) {
            self.showingPlayerLabel.layer.opacity = 0.0
        }
        showingPlayerLabel.isHidden = true
        
        readyButton.setTitle("Угадано!", for: .normal)
    }
    
    //Кнопка в titleView navigationBar
    private func configMiddleBarButton() {
        let titleButton =  UIButton(type: .custom)
        let viewHeight = view.bounds.height
        let viewWidth = view.bounds.width
        titleButton.frame = CGRect(x: 0, y: 0, width: viewWidth / 2, height: viewHeight / 25)
        titleButton.backgroundColor = .clear
        titleButton.setTitle("Рейтинг", for: .normal)
        titleButton.titleLabel?.textAlignment = .center
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
            guard let navigationTitleButton = self.navigationItem.titleView as? UIButton  else { return }
            navigationTitleButton.setTitle("Выберите угадавшего", for: .normal)
            navigationTitleButton.setImage(UIImage(), for: .normal)
            presentIncreaseScoreScreenViewController()
            hideWord()
        }
        gameStateToggle()
    }
    
    //Нажата кнопка сдаться
    @IBAction func giveUpButtonAction(_ sender: UIButton) {
        guard let gameManager = gameManager else { return }
        gameManager.giveUpButtonPressed()
        wordLabel.alpha = 0.0
        giveUpButton.alpha = 0.0
        giveUpButton.isHidden = true
        gameState = .waiting
        //readyButton.setTitle("Готов!", for: .normal)
    }
    
    @objc
    func scoreCenterBarButtonAction() {
        delegate?.GameViewControllerDidPressRatingButton(self)
    }
    
    //скрывает старое слово после сдачи или отгадывания
    private func hideWord() {
        wordLabel.alpha = 0.0
        giveUpButton.alpha = 0.0
        giveUpButton.isHidden = true
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
        giveUpButton.isHidden = false
        giveUpButton.alpha = 1.0
        //readyButton.setTitle("Угадано!", for: .normal)
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
        delegate?.GameViewControllerDidPressGuessed(self, onDismissed: onDismissed)
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
