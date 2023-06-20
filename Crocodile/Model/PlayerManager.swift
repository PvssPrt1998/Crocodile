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
    //Массив игроков
    private var players: [Player] = []
    
    //MARK: - Methods
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
    public func incrementPlayerScore() {
        
    }
    
    //Забрать очко у игрока
    public func decrementPlayerScore() {
        
    }
    
    
}
