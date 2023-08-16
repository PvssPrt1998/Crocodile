//
//  AddPlayerTableViewCell.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

//MARK: - AddPlayerTableViewCell
class AddPlayerTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    //Добавлен ли игрок (свойство нужно чтобы перещелкивать с крестика на галочку и наоборот)
    var isPlayerAdded: Bool = false {
        didSet {
            if oldValue != isPlayerAdded {
                toggleImageOnPlayerButton()
            }
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var playerNameTextField: PlayerNameTextField!
    @IBOutlet weak var playerButton: UIButton!
    
    //Делегат для того чтобы прокинуть sender UIButton во viewController
    weak var delegate: PlayerButtonActionDelegate?
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerNameTextField.setupLayers()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let borderWidth: CGFloat = 2
        let cornerRadius: CGFloat = playerNameTextField.bounds.width / 30
        playerNameTextField.setupLayers(with: borderWidth, and: cornerRadius)
    }
    
    //MARK: - Actions
    //Событие которое срабатывает при изменении playerNameTextField
    @IBAction func playerNameTextFieldDidChange(_ sender: UITextField) {
        playerButtonActiveCondition()
    }
    
    //Нажата кнопка playerButton. Если поле при нажатии заполнено и картинка на кнопке - галочка (добавляем нового игрока), то
    //Если поле заполнено и кнопка крестик, то мы удаляем игрока.
    //Если поле пустое, то кнопка неактивна.
    @IBAction func playerButtonAction(_ sender: UIButton) {
        delegate?.playerButtonPressed(sender: sender)
        //перещелкиваем картинку и isPlayerAdded. Сначала щелкаем isPlayerAdded
        isPlayerAdded.toggle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    //Метод который проверяет условие должна ли быть кнопка playerButton активна или наоборот (пустое ли поле игрока или нет)
    func playerButtonActiveCondition() {
        let playerName = playerNameTextField.text ?? ""
        if playerName != "" {
            guard let delegate = delegate else { return }
            //если игрока в массиве еще нет
            if !delegate.isPlayerAddedNow(playerName) {
                makePlayerButtonActive()
            } else {
                // TODO: - если игрок с таким именем уже есть в массиве игроков, то мы не делаем кнопку активной и отображаем строчку
                //"такой игрок уже есть, добавьте другое имя"
            }
        } else {
            makePlayerButtonInactive()
        }
    }
    
    //MARK: - Private methods
    //Меняет картинку галочка или крестик
    private func toggleImageOnPlayerButton() {
        switch isPlayerAdded {
        case true: playerButton.setImage(UIImage(systemName: "clear")!, for: .normal)
            playerNameTextField.isUserInteractionEnabled = false
        case false: playerButton.setImage(UIImage(systemName: "checkmark.circle")!, for: .normal)
            playerNameTextField.isUserInteractionEnabled = true
        }
    }

    
    
    //Сделать кнопку неактивной (Поле игрока пустое). Прозрачность почти 100%
    private func makePlayerButtonInactive() {
        playerButton.alpha = 0.1
        playerButton.isEnabled = false
    }
    
    //Сделать кнопку активной (Поле игрока непустое). Прозрачность почти 0%. Кнопку отлично видно
    private func makePlayerButtonActive() {
        playerButton.alpha = 1.0
        playerButton.isEnabled = true
    }
    
    //сбросить сell до значений по умолчанию. Необходимо, потому что ячейки в коллекшн вью переиспользуются
    //и после удаления ячейки не перезагружая таблицу, новая ячейка создастся с данными ранее хранимыми в ней
    public func resetCell() {
        playerNameTextField.text = ""
        makePlayerButtonInactive()
        isPlayerAdded = false
        playerNameTextField.placeholder = ""
    }
}
