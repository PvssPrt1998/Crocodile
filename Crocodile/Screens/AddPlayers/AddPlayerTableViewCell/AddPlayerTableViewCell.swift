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
    
    //массив UIImage галочка и крестик
    let checkmarkImageArray = [UIImage(systemName: "checkmark.circle")!, UIImage(systemName: "clear")!]
    //
    
    //MARK: - Methods
//    let innerShadow = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerNameTextField.sizeForCalculateLayout = 200
        print(contentView.bounds.width)
        playerNameTextField.addLayer()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        playerNameTextField.setupLayer()
    }
//
    //MARK: - AddPlayersTextField Layer
    
//    func setupPlayerTextField() {
//        let cornerRadius = contentView.bounds.width / 30
//        let borderWidth: CGFloat = 2
//        let textFieldInset: CGFloat = (borderWidth * 2) + (cornerRadius / 2)
//
//        //let innerShadow = CALayer()
//        innerShadow.frame = playerNameTextField.bounds
//
//        let radius = cornerRadius
//        let dx: CGFloat = -borderWidth
//        let dy: CGFloat = -borderWidth
//        let path = UIBezierPath(roundedRect: layer.bounds.insetBy(dx: dx, dy: dy), cornerRadius: radius + dy)
//        let cutout = UIBezierPath(roundedRect: layer.bounds, cornerRadius:radius).reversing()
//
//        path.append(cutout)
//
//        innerShadow.shadowPath = path.cgPath
//        innerShadow.masksToBounds = true
//        innerShadow.shadowColor = UIColor.black.cgColor
//        innerShadow.shadowOffset = CGSize(width: 0, height: 0)
//        innerShadow.shadowOpacity = 1
//        innerShadow.shadowRadius = 3
//
//        playerNameTextField.layer.addSublayer(innerShadow)
//
//        playerNameTextField.layer.opacity = 0.6
//        playerNameTextField.layer.cornerRadius = cornerRadius
//        playerNameTextField.layer.borderWidth = borderWidth
//        playerNameTextField.layer.borderColor = UIColor.white.cgColor
//        playerNameTextField.layer.masksToBounds = true
//
//        playerNameTextField.setLeftPaddingPoints(textFieldInset)
//        playerNameTextField.setRightPaddingPoints(textFieldInset)
//        playerNameTextField.tintColor = .gray
//    }
    
    //MARK: - DEPECATED
    private func innerShadowPath(for layer: CALayer, with radius: CGFloat) -> CGPath {
        let radius = radius
        let dx: CGFloat = -1
        let dy: CGFloat = -1
        let path = UIBezierPath(roundedRect: layer.bounds.insetBy(dx: dx, dy: dy), cornerRadius: radius + dy)
        let cutout = UIBezierPath(roundedRect: layer.bounds, cornerRadius:radius).reversing()
            
        path.append(cutout)
        return path.cgPath
    }
    
    private func setupInnerShadowForPlayerNameTextField(with cornerRadius: CGFloat) {
        let innerShadow = CALayer()
        innerShadow.frame = playerNameTextField.bounds
        innerShadow.cornerRadius = cornerRadius
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 0)
        innerShadow.shadowOpacity = 0.8
        innerShadow.shadowRadius = 3
        innerShadow.masksToBounds = true
        playerNameTextField.layer.addSublayer(innerShadow)
    }
    
    private func setupPlayerNameTextFieldLayer() {
        let cornerRadius = contentView.bounds.width / 30
        let borderWidth: CGFloat = 2
        
        playerNameTextField.layer.cornerRadius = cornerRadius
        playerNameTextField.layer.borderWidth = borderWidth
        playerNameTextField.layer.borderColor = UIColor.white.cgColor
        playerNameTextField.layer.opacity = 0.6
        let textFieldInset: CGFloat = (borderWidth * 2) + (cornerRadius / 2)
        playerNameTextField.setLeftPaddingPoints(textFieldInset)
        playerNameTextField.setRightPaddingPoints(textFieldInset)
        playerNameTextField.tintColor = .gray
        
        setupInnerShadowForPlayerNameTextField(with: cornerRadius)
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
    
    //Меняет картинку галочка или крестик. Также меняет isPlayerAdded, что влияет на логику
    private func toggleImageOnPlayerButton() {
        switch isPlayerAdded {
        case true: playerButtonSetImage(checkmarkImageArray[1])
            playerNameTextField.isUserInteractionEnabled = false
        case false: playerButtonSetImage(checkmarkImageArray[0])
            playerNameTextField.isUserInteractionEnabled = true
        }
    }
    
    //Устанавливает картинку для кнопки playerButton
    private func playerButtonSetImage(_ image: UIImage) {
        playerButton.setImage(image, for: .normal)
    }

    //Метод который проверяет условие должна ли быть кнопка playerButton активна или наоборот (пустое ли поле игрока или нет)
    private func playerButtonActiveCondition() {
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
