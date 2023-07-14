//
//  PlayerManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 19.06.2023.
//

import Foundation

//Класс управления игроками
//Хранит всех игроков
//Может удалять игроков
//Может добавлять
public class PlayerManager {
    //MARK: - Properties
    //TODO: - Change to Struct
    var currentPlayer: (Player,Int)?
    //Массив игроков
    private var players: [Player] = []
    
    //MARK: - Methods
    //устанавливает текущим игроком первого игрока из массива игроков
    public func setCurrentPlayerFirst() {
        guard let player = players.first else { return }
        currentPlayer?.0 = player
        currentPlayer?.1 = 0
    }
    
    //Cледующий игрок
    public func makeNextPlayerCurrent() {
        guard var currentPlayer = currentPlayer else { return }
        //Если индекс меньше или равен индексу предпоследнего элемента массива, то плюс один. Иначе скидываем до нуля
        if currentPlayer.1 < playersCount() - 1 {
            //increment index of current player
            currentPlayer.1 += 1
        } else {
            //assign currentPlayer index to 0
            currentPlayer.1 = 1
        }
        //assign other player current by new index
        currentPlayer.0 = players[currentPlayer.1]
    }
    
    //Операция с очками игрока
    public func setCurrentPlayerScore(to score: Int) {
        guard let currentPlayer = currentPlayer else { return }
        currentPlayer.0.score += score
    }
    
    //добавить игрока
    public func addPlayer(_ playerName: String) {
        //проверка сли такой игрок уже есть, то не добавляет
        guard !isPlayerAddedNow(playerName) else { return }
        //Если такого игрока нет, то добавляем в массив
        players.append(Player(name: playerName))
    }
    //Проверка есть ли уже в массиве такой игрок
    private func isPlayerAddedNow(_ playerName: String) -> Bool {
        players.contains { $0.name == playerName }
    }
    
    //Удаление игрока
    //Удаление по имени
    public func removePlayer(by name: String) {
        guard let index = players.firstIndex(where: { $0.name == name }) else { return }
        players.remove(at: index)
    }
    
    //Удаление по индексу
    public func removePlayer(by index: Int) {
        //проверяем находится ли индекс в границах массива
        guard index < players.count else { return }
        //удаляем игрока
        players.remove(at: index)
    }
    
    //Вернуть количество игроков
    public func playersCount() -> Int {
        players.count
    }
    
    //Добавить очко игроку
    public func incrementPlayerScore(by name: String) {
        guard let index = players.firstIndex(where: { $0.name == name }) else { return }
        players[index].score += 1
    }
    
    //Забрать очко у игрока
    public func decrementPlayerScore() {
        
    }
    
    //забрать очко у текущего игрока (сдался или не смог нормально показать слово)
    public func decrementCurrentPlayerScore() {
        setCurrentPlayerScore(to: -1)
    }
    
    public func getPlayerNameWithIndex(_ index: Int)-> String {
        return players[index].name
    }
    
    public func getPlayerScoreWithIndex(_ index: Int)-> Int {
        return players[index].score
    }
}
