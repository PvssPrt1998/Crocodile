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

//MARK: - TimerRunChildViewControllerDelegate
public protocol TimerRunChildViewControllerDelegate: AnyObject {
    func runTimer()
}

public final class GameScreenViewController: UIViewController {
    
    //MARK: - Properties
    var gameManager: GameManager?

    //Делегатом выступает координатор данного контроллера
    public weak var delegate: GameScreenViewControllerDelegate?
    
    weak var timerDelegate: TimerRunChildViewControllerDelegate?
    
    private lazy var onDismissed: ()->Void = {
        guard let navigationTitleButton = self.navigationItem.titleView as? UIButton  else { return }
        navigationTitleButton.setTitle("Рейтинг", for: .normal)
        navigationTitleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var gameContainerView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var mainButton: MainButton!
    @IBOutlet weak var giveUpButton: UIButton!
    @IBOutlet weak var showingPlayerLabel: UILabel!
    
    //MARK: - ViewController LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        gameManager?.playerManager.setCurrentPlayer()
        setupViewConfigs()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameContainerView.layer.cornerRadius = view.frame.width / 30
    }
    
    //MARK: - Segue
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? TimerContainerViewGameScreenViewController else { return }
        destinationViewController.delegate = self
        timerDelegate = destinationViewController
    }
    
    //MARK: - Configure views methods
    //задает нужный текст для лейблов и кнопок при загрузке
    private func setupViewConfigs() {
        configMiddleBarButton()
        prepareViewsForWaitingState()
        mainButton.delegate = self
    }
    
    //готовит вьюшки для состояния ожидания готовности игрока
    private func prepareViewsForWaitingState() {
        timerContainerView.isHidden = true
        guard let gameManager = gameManager else { return }
        let showingPlayerLabelText = gameManager.playerManager.currentPlayer!.name
        showingPlayerLabel.text = "Показывает игрок: \(showingPlayerLabelText)"
        //отображаем лейбл с именем показывающего
        showingPlayerLabel.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.showingPlayerLabel.layer.opacity = 1.0
            self.giveUpButton.layer.opacity = 0.0
            self.wordLabel.layer.opacity = 0.0
        }
        wordLabel.isHidden = true
        giveUpButton.isHidden = true
        
        mainButton.setTitle("Готов!", for: .normal)
    }
    
    //готовит вьюшки для состояния "игра в процессе"
    private func prepareViewsForInProgressState() {
        timerContainerView.isHidden = false
        timerDelegate?.runTimer()
        wordLabel.text = gameManager?.wordManager.currentWord
        wordLabel.isHidden = false
        giveUpButton.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.wordLabel.layer.opacity = 1.0
            self.giveUpButton.layer.opacity = 1.0
            self.showingPlayerLabel.layer.opacity = 0.0
        }
        showingPlayerLabel.isHidden = true
        mainButton.setTitle("Угадано!", for: .normal)
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
    //Нажата кнопка сдаться
    @IBAction func giveUpButtonAction(_ sender: UIButton) {
        gameManager?.giveUp()
    }
    
    @objc
    func scoreCenterBarButtonAction() {
        delegate?.GameViewControllerDidPressRatingButton(self)
    }
    
    //Срабатывает если кто-то угадал слово и показывающий игрок нажал на кнопку "Угадано!"
    //Открывает IncreasePlayerScoreScreenViewController где показывающий выбирает отгадавшего
    func presentIncreaseScoreScreenViewController() {
        prepareNavigationItemForIncreaseViewController()
        delegate?.GameViewControllerDidPressGuessed(self, onDismissed: onDismissed)
    }
    private func prepareNavigationItemForIncreaseViewController() {
        guard let navigationTitleButton = self.navigationItem.titleView as? UIButton  else { return }
        navigationTitleButton.setTitle("Выберите угадавшего", for: .normal)
        navigationTitleButton.setImage(UIImage(), for: .normal)
    }
    
    func setGameManager(data: AnyObject) {
        guard let data = data as? GameManager else { return }
        gameManager = data
        gameManager?.delegate = self
    }
}

//MARK: - StoryboardInstantiable
extension GameScreenViewController: StoryboardInstantiable {
    public class func instantiate(delegate: GameScreenViewControllerDelegate) -> GameScreenViewController {
        let viewController = instanceFromStoryboard()
        viewController.delegate = delegate
        return viewController
    }
}


//MARK: - Observer
extension GameScreenViewController: GameStateDelegate {
    
    public func prepareGameForInProgressState() {
        prepareViewsForInProgressState()
    }
    
    public func prepareGameForWaitingState() {
        prepareViewsForWaitingState()
    }
}

extension GameScreenViewController: TimeOutDelegate {
    func timeOut() {
        gameManager?.giveUp()
    }
}
