//
//  ScoreViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 27.04.2023.
//

import UIKit

public class ScoreScreenViewController: UIViewController {
    
    //MARK: - Properties
    var gameManager: GameManager?
    
    //массив который мы сортируем по очкам
    var playersScoreArray: Array<(String,Int)> = []
    
    //MARK: - IBOutlets
    @IBOutlet weak var playersScoreTableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlayersArray()
    }
    
    //Засовывает из гейм менеджера данные в массив и запускает его сортировку по очкам
    //TODO: - вынести в геймменеджер функцию с возвратом отсортированного массива
    private func setupPlayersArray() {
        guard let gameManager = gameManager else { return }
        let upperBound = gameManager.playerManager.playersCount() - 1
        for index in 0...upperBound {
            let name = gameManager.playerManager.getPlayerNameWithIndex(index)
            let score = gameManager.playerManager.getPlayerScoreWithIndex(index)
            playersScoreArray.append((name, score))
        }
        guard let player = gameManager.playerManager.currentPlayer else { return }
        playersScoreArray.append((player.name, player.score))
        
        //вызов сортировки массива
        sortPlayersArray()
    }
    
    //сортировка массива по очкам
    private func sortPlayersArray() {
        playersScoreArray.sort { $0.1 > $1.1 }
    }
}

//MARK: - UITableViewDataSource
extension ScoreScreenViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gameManager = gameManager else { return 0 }
        //playersCount это не все игроки. Есть еще currentPlayer которого надо учитывать тоже
        return gameManager.playerManager.playersCount() + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? ScoreTableViewCell else { return UITableViewCell() }
        
        let index = indexPath.row
        cell.playerNameLabel.text = playersScoreArray[index].0
        cell.playerScoreLabel.text = String(playersScoreArray[index].1)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ScoreScreenViewController: UITableViewDelegate {
    
}

//MARK: - StoryboardInstantiable extension
extension ScoreScreenViewController: StoryboardInstantiable {
    public class func instantiate() -> ScoreScreenViewController {
        let viewController = instanceFromStoryboard()
        return viewController
    }
}
