//
//  AddPlayerViewController+UITableViewDataSource.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.08.2023.
//

import UIKit

//MARK: - UITableViewDataSource
extension AddPlayersViewController: UITableViewDataSource {
    //Количество строк в секции таблицы (равно количеству игроков). В этой таблице только одна секция с игроками.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gameManager = gameManager else { return 0 }
        return gameManager.playerManager.playersCount() + 1
    }
    //Инициализируем строку здесь
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addPlayerCell", for: indexPath) as? AddPlayerTableViewCell else {
            return UITableViewCell()
        }
        //Сбрасываем cell чтобы у нас не при добавлении не появлялись заполненные cell
        cell.resetCell()
        //Назначаем делегатом этот viewController, чтобы при нажатии на кнопку cell срабатывал метод вьюконтроллера
        cell.delegate = self
        //Выключаем видимый эффект выделения ячейки
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}
