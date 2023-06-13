//
//  AddPlayerTableViewCell.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

//MARK: - AddPlayerTableViewCell
class AddPlayerTableViewCell: UITableViewCell {
    
    deinit {
        print("deinitedCELL")
    }
    
    //Добавлен ли игрок
    var isPlayerAdded: Bool = false
    //Outlets
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerButton: UIButton!
    
    //Делегат для того чтобы прокинуть sender UIButton во viewController
    weak var delegate: playerButtonActionDelegate? 
    
    //массив UIImage галочка и крестик
    let checkmarkImageArray = [UIImage(systemName: "checkmark.circle")!, UIImage(systemName: "clear")!]
    //
    
    //Событие которое срабатывает при изменении playerNameTextField
    @IBAction func playerNameTextFieldDidChange(_ sender: UITextField) {
        playerButtonActiveCondition()
    }
    
    //Нажата кнопка playerButton. Если поле при нажатии заполнено и картинка на кнопке - галочка (добавляем нового игрока), то
    //Если поле заполнено и кнопка крестик, то мы удаляем игрока.
    //Если поле пустое, то кнопка неактивна.
    @IBAction func playerButtonAction(_ sender: UIButton) {
        delegate?.changeDescription(sender: sender)
        //перещелкиваем картинку и isPlayerAdded. Сначала щелкаем isPlayerAdded
        isPlayerAdded.toggle()
        toggleImageOnPlayerButton()
    }
    
    //Меняет картинку галочка или крестик. Также меняет isPlayerAdded, что влияет на логику
    private func toggleImageOnPlayerButton() {
        switch isPlayerAdded {
        case false: playerButtonSetImage(checkmarkImageArray[0])
            playerNameTextField.isUserInteractionEnabled = true
        case true: playerButtonSetImage(checkmarkImageArray[1])
            playerNameTextField.isUserInteractionEnabled = false
        }
    }
    
    //Устанавливает картинку для кнопки playerButton
    private func playerButtonSetImage(_ image: UIImage) {
        playerButton.setImage(image, for: .normal)
    }
    

    //Метод который проверяет условие должна ли быть кнопка playerButton активна или наоборот (пустое ли поле игрока или нет)
    private func playerButtonActiveCondition() {
        if playerNameTextField.text != "" {
            makePlayerButtonActive()
        } else {
            makePlayerButtonInactive()
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
    
    //сбросить сell до значений по умолчанию.
    public func resetCell() {
        super.prepareForReuse()
        isPlayerAdded = false
        playerNameTextField.text = ""
        playerButtonSetImage(checkmarkImageArray[0])
    }
}
