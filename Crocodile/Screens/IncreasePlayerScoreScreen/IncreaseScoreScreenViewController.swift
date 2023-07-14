//
//  IncreaseScoreScreenViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 09.07.2023.
//

import UIKit

//MARK: - CoordinatorDelegate
public protocol IncreasePlayerScoreScreenViewControllerDelegate: AnyObject {
    func increasePlayerScoreScreenViewControllerDidPressDone()
}

//MARK: - IncreasePlayerScoreScreenViewController
public class IncreasePlayerScoreScreenViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var playersTableView: UITableView!
    
    //MARK: - Public properties
    //Delegate
    public weak var delegate: IncreasePlayerScoreScreenViewControllerDelegate?
    
    //GameManager
    var gameManager: GameManager?
    
    //MARK: - Private properties
    //массив который мы сортируем по алфавиту
    var playersNamesArray: Array<String> = []
    
    //currentHeight определяет высоту контроллера при презентации
    private var currentHeight: CGFloat = 50
    //currentWidth определяет ширину контроллера при презентации
    private var currentWidth: CGFloat = 50
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayersArray()
        updatePreferredContentSize()
    }
    
    //MARK: - Private methods
    //Засовывает из гейм менеджера данные в массив и запускает его сортировку по имени
    private func setupPlayersArray() {
        guard let gameManager = gameManager else { return }
        let upperBound = gameManager.playerManager.playersCount() - 1
        for index in 0...upperBound {
            let name = gameManager.playerManager.getPlayerNameWithIndex(index)
            playersNamesArray.append(name)
        }
        //вызов сортировки массива
        sortPlayersArray()
    }
    
    //сортировка массива по очкам
    private func sortPlayersArray() {
        playersNamesArray.sort { $0 < $1 }
    }
    
    private func updatePreferredContentSize() {
        preferredContentSize = .init(width: currentWidth, height: currentHeight)
    }
}

//MARK: - StoryboardInstantiable extension
extension IncreasePlayerScoreScreenViewController: StoryboardInstantiable {
    public class func instantiate(delegate: IncreasePlayerScoreScreenViewControllerDelegate, currentHeight: CGFloat, currentWidth: CGFloat) -> IncreasePlayerScoreScreenViewController {
        let viewController = instanceFromStoryboard()
        viewController.currentHeight = currentHeight
        viewController.currentWidth = currentWidth
        viewController.delegate = delegate
        return viewController
    }
}

extension IncreasePlayerScoreScreenViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gameManager = gameManager else { return 0 }
        return gameManager.playerManager.playersCount()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerNameCell", for: indexPath) as? PlayersTableViewCell
        else { return UITableViewCell() }
        cell.playerNameLabel.text = playersNamesArray[indexPath.row]
        return cell
    }
}

extension IncreasePlayerScoreScreenViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlayersTableViewCell else { return }
        let name = cell.playerNameLabel.text!
        gameManager?.playerManager.incrementPlayerScore(by: name)
        delegate?.increasePlayerScoreScreenViewControllerDidPressDone()
    }
}
