//
//  AddPlayerViewController+PlayerButtonActionDelegate.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.08.2023.
//

import UIKit

//MARK: -ChangeDescriptionDelegate
extension AddPlayersViewController: PlayerButtonActionDelegate {
    
    //метод который вызывается при нажатии на кнопку в целл классе
    public func playerButtonPressed(sender: UITableViewCell) {
        //проверяем cell и indexPath на nil
        guard let gameManager = gameManager,
              let cell = sender as? AddPlayerTableViewCell,
              let indexPath = getIndexPathBy(cell: cell)
        else { return }
        
        //force unwrap потому что текст точно есть в текстфилде. Если бы текста не было, кнопка бы не нажалась и метод бы не сработал
        let playerName = cell.playerNameTextField.text!
        
        //Если игрок не добавлен, то добавляем
        if cell.isPlayerAdded == false {
            //добавляем игрока
            gameManager.playerManager.addPlayer(playerName)
            //создаем пустую строку в начале таблицы для ввода имени нового игрока
            insertRow()
        } else { //Если игрок добавлен и мы нажимаем крестик
            //удаляем игрока в по индекс пасс. В таблице и в массиве игрок на одном и том же индексе
            gameManager.playerManager.removePlayer(by: playerName)
            //Удаляем строку по индекс пассу
            deleteRow(by: indexPath)
        }
    }
    
    //Удалить строку по indexPath
    private func deleteRow(by indexPath: IndexPath) {
        guard let cell = addPlayersTableView.cellForRow(at: indexPath) else { return }
        cell.prepareForReuse()
        addPlayersTableView.beginUpdates()
        addPlayersTableView.deleteRows(at: [indexPath], with: .fade)
        addPlayersTableView.endUpdates()
        //Проверяем есть ли игроки и нужно ли отображать nextButton. Если нет, то скрыть
        mainButtonAvailabilityCheck()
        firstCellAddAvailabilityCheck()
    }
    
    //Добавить пустую строку для ввода в конец таблицы
    private func insertRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        addPlayersTableView.beginUpdates()
        addPlayersTableView.insertRows(at: [indexPath], with: .fade)
        addPlayersTableView.endUpdates()
        guard let cell = addPlayersTableView.cellForRow(at: indexPath) as? AddPlayerTableViewCell else { return }
        cell.playerNameTextField.becomeFirstResponder()
        //Проверяем есть ли игроки и нужно ли отображать nextButton. Если нет, то скрыть
        mainButtonAvailabilityCheck()
    }
    
    //Если в первом текстфилде написано имя, но не добавлено, а мы удалили игрока с таким же именем, которое введено в текстфилде
    //галочка должна загореться
    private func firstCellAddAvailabilityCheck() {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = addPlayersTableView.cellForRow(at: indexPath) as? AddPlayerTableViewCell else { return }
        cell.playerButtonActiveCondition()
    }
    
    //Метод, проверяющий можно ли отображать nextButton или нужно скрыть
    private func mainButtonAvailabilityCheck() {
        guard let gameManager = gameManager else { return }
        //Если игроки не введены
        let playersCount = gameManager.playerManager.playersCount()
        //если игроков меньше двух, то играть не получится кнопка. не отобразится просто (игра не для одного)
        if playersCount < 2 {
            mainButton.makeInvisible()
        } else {
            mainButton.makeVisible()
        }
    }
    
    public func isPlayerAddedNow(_ player: String) -> Bool {
        gameManager?.playerManager.isPlayerAddedNow(player) ?? false
    }
    
    //В cell классе нажимается кнопка, мы получаем эту кнопку и ищем для неё супервью и так далее пока не найдем сслыку на cell
    private func getCellByUIView(_ view: UIView)-> AddPlayerTableViewCell? {
        //берем супервью для баттона
        var superview = view.superview
        //если вью не cell то берем супервью для вью пока не будет cell
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        //проверяем можем ли пропарсить для нашего кастомного целл и получаем целл типа нашего целл
        guard let cell = superview as? AddPlayerTableViewCell else { return nil }
        return cell
    }
    
    //и используя аутлет таблицы получаем indexPath имея cell
    private func getIndexPathBy(cell: AddPlayerTableViewCell)-> IndexPath? {
        //получаем индекс пасс если можем
        guard let indexPath = addPlayersTableView.indexPath(for: cell) else { return nil }
        //возвращаем indexPath
        return indexPath
    }
}
