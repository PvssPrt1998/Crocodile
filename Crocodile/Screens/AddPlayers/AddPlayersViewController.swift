//
//  AddPlayersViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

//MARK: - CoordinatorDelegate
public protocol AddPlayersViewControllerDelegate: AnyObject {
    func addPlayersViewControllerDidPressNext(_ viewController: AddPlayersViewController)
}

//MARK: - PlayerButtonActionDelegate
//Используется для передачи sender из cell во viewController
public protocol playerButtonActionDelegate: AnyObject {
    func changeDescription(sender: UIButton)
}

//MARK: - UIViewController (AddPlayersViewController)
public class AddPlayersViewController: UIViewController {

    //MARK: - Delegate
    public weak var delegate: AddPlayersViewControllerDelegate?
    
    //GameManager
    var gameManager: GameManager?
    
    //MARK: - Outlets
    @IBOutlet weak var addPlayersTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - ViewControlletLifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Кнопка перехода к экрану игры
    @IBAction func nextButtonAction(_ sender: UIButton) {
        delegate?.addPlayersViewControllerDidPressNext(self)
    }
    
    
    //Удалить строку по indexPath
    private func deleteRow(by indexPath: IndexPath) {
        addPlayersTableView.beginUpdates()
        addPlayersTableView.deleteRows(at: [indexPath], with: .automatic)
        addPlayersTableView.endUpdates()
        //Проверяем есть ли игроки и нужно ли отображать nextButton. Если нет, то скрыть
        nextButtonCheck()
    }
    
    //Добавить строку в конец таблицы
    private func insertRow() {
        guard let gameManager = gameManager else { return }
        addPlayersTableView.beginUpdates()
        addPlayersTableView.insertRows(at: [IndexPath(row: gameManager.players.count, section: 0)], with: .automatic)
        addPlayersTableView.endUpdates()
        //Проверяем есть ли игроки и нужно ли отображать nextButton. Если нет, то скрыть
        nextButtonCheck()
    }
    
    //Метод, проверяющий можно ли отображать nextButton или нужно скрыть
    private func nextButtonCheck() {
        guard let gameManager = gameManager else { return }
        //Если игроки не введены
        if gameManager.players.isEmpty {
            animateNextButton(opacity: 0)
            //Выключаем кнопку
            nextButton.isEnabled = false
        } else {
            animateNextButton(opacity: 1.0)
            //Включаем кнопку
            nextButton.isEnabled = true
        }
    }
    
    //Метод с анимацией появления nextButton либо сокрытия
    private func animateNextButton(opacity: Float) {
        UIView.animate(withDuration: 0.2) {  [] in
            //меняем прозрачность
            self.nextButton.layer.opacity = opacity
        }
    }
}
//

//MARK: -ChangeDescriptionDelegate
extension AddPlayersViewController: playerButtonActionDelegate {
    
    //метод который вызывается при нажатии в целл классе
    public func changeDescription(sender: UIButton) {
        //
        //Мы ищем супервью для button в tableViewCell чтобы работало удаление
        //
        //берем супервью для баттона
        var superview = sender.superview
        //если вью не cell то берем супервью для вью пока не будет cell
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        //проверяем можем ли пропарсить для нашего кастомного целл и получаем целл типа нашего целл
        guard let cell = superview as? AddPlayerTableViewCell else { return }
        //получаем индекс пасс если можем
        guard let indexPath = addPlayersTableView.indexPath(for: cell) else { return }
        
        //Если игрок не добавлен
        if cell.isPlayerAdded == false {
            gameManager?.addPlayer(cell.playerNameTextField.text!)
            insertRow()
        } else { //Если игрок добавлен и мы нажимаем крестик
            //удаляем игрока в по индекс пасс. В таблице и в массиве игрок на одном и том же индексе.
            gameManager?.removePlayer(by: indexPath.row)
            //Сбрасываем cell чтобы у нас не при добавлении не появлялись заполненные cell
            cell.resetCell()
            //Удаляем строку по индекс пассу
            deleteRow(by: indexPath)
        }
    }
}

//MARK: - UITableViewDelegate
extension AddPlayersViewController: UITableViewDelegate {
    //Событие после нажатия на строку
    public func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        tableView.deselectRow(at: didSelectRowAt, animated: false)
    }
}

//MARK: - UITableViewDataSource
extension AddPlayersViewController: UITableViewDataSource {
    //Количество строк в секции таблицы (равно количеству игроков). В этой таблице только одна секция с игроками.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gameManager = gameManager else { return 0 }
        return gameManager.players.count + 1
    }
    //Инициализируем строку здесь
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addPlayerCell", for: indexPath) as? AddPlayerTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
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
