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
    var currentPlayer: Player?
    //Массив игроков
    private var players: [Player] = []
    
    //MARK: - Methods
    //устанавливает текущим игроком первого игрока из массива игроков
    public func setCurrentPlayer() {
        guard players.first != nil else { return }
        let player = players.removeFirst()
        currentPlayer = player
        players.append(player)
    }
    
    public func playersSortedArray() -> Array<(String, Int)> {
        var sortedPlayers: Array<(String, Int)> = []
        players.forEach { player in
            let name = player.name
            let score = player.score
            sortedPlayers.append((name, score))
        }
        sortedPlayers.sort { $0.1 > $1.1 }
        return sortedPlayers
    }
    
    //Операция с очками игрока
    public func setCurrentPlayerScore(to score: Int) {
        guard let currentPlayer = currentPlayer else { return }
        currentPlayer.score += score
    }
    
    //добавить игрока
    public func addPlayer(_ playerName: String) {
        //проверка сли такой игрок уже есть, то не добавляет
        guard !isPlayerAddedNow(playerName) else { return }
        //Если такого игрока нет, то добавляем в массив
        players.append(Player(name: playerName))
    }
    
    //Проверка есть ли уже в массиве такой игрок
    public func isPlayerAddedNow(_ playerName: String) -> Bool {
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
