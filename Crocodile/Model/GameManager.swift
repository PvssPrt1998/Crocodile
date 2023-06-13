//
//  GameManager.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import Foundation

public class GameManager {
    
    var players: [Player] = []
    var categories: [Category] = []
    
    var memesWords: Set = ["MemeWord1", "MemeWord2", "MemeWord3", "MemeWord4", "MemeWord5", "MemeWord6", "MemeWord7", "MemeWord8", "MemeWord9", "MemeWord10", "MemeWord11", "MemeWord12", "MemeWord13", "MemeWord14", "MemeWord15"]
    var over18words: Set = ["over18words1", "over18words2", "over18words3", "over18words4", "over18words5", "over18words", "over18words7", "over18words8", "over18words9", "over18words10", "over18words11", "over18words12", "over18words13", "over18words14", "over18words15"]
    
    
    public func addPlayer(_ player: String) {
        players.append(Player(name: player))
    }
    
    public func removePlayer(by name: String) {
        guard let index = players.firstIndex(where: { $0.name == name }) else { return }
        players.remove(at: index)
    }
    
    public func removePlayer(by index: Int) {
        guard index < players.count else { return }
        print("removeIndex = \(index)")
        players.remove(at: index)
    }

    public func loadWords() {
        categories.append(Category(title: "Memes", wordsSet: memesWords))
        categories.append(Category(title: "Over18", wordsSet: over18words))
    }
    
    public func selectToggle(by index: Int) {
        categories[index].toggleSelected()
    }
    
    public func isAnySelected() -> Bool {
        return categories.contains { $0.isSelected == true }
    }
}
