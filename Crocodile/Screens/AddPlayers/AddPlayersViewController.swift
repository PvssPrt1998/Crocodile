//
//  AddPlayersViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 18.04.2023.
//

import UIKit

//MARK: - CoordinatorDelegate
public protocol AddPlayersViewControllerDelegate: AnyObject {
    func addPlayersViewControllerDidPressNext(_ viewController: AddPlayersViewController, onDismissed: (()->Void)?)
}

//MARK: - PlayerButtonActionDelegate
//Используется для передачи sender из cell во viewController
public protocol PlayerButtonActionDelegate: AnyObject {
    func playerButtonPressed(sender: UITableViewCell)
    func isPlayerAddedNow(_ player: String)-> Bool
}

//MARK: - UIViewController (AddPlayersViewController)
public class AddPlayersViewController: UIViewController {

    //MARK: - Delegate
    public weak var delegate: AddPlayersViewControllerDelegate?
    
    //GameManager
    var gameManager: GameManager?
    
    lazy var onDismissed: ()->Void = {
        self.gameManager?.reset()
    }
    
    //MARK: - Outlets
    @IBOutlet weak var addPlayersTableView: UITableView!
    @IBOutlet weak var mainButton: MainButton!
    
    @IBOutlet weak var mainButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButtonWidthConstraint: NSLayoutConstraint!
    
    //MARK: - ViewControlletLifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupMainButton()
        addKeyboardObservers()

        addPlayersTableView.separatorStyle = .none
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addPlayersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height - mainButton.frame.origin.y, right: 0)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.becomeFirstResponder()
        view.endEditing(true)
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        let keyboardSize = frame.cgRectValue.size
        mainButtonCenterXConstraint.constant = view.frame.height / 2 - keyboardSize.height - mainButton.frame.height / 2 - 8
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        mainButtonCenterXConstraint.constant = (view.frame.height / 2) * 0.8
    }
    
    private func setupMainButton() {
        mainButton.hide()
        mainButton.delegate = self
        mainButton.setTitle("Далее", for: .normal)
        makeMainButtonNormal()
    }
    
    func setGameManager(data: AnyObject) {
        guard let data = data as? GameManager else { return }
        gameManager = data
    }
    
    //уменьшает кнопку при тач даун
    func makeMainButtonSmaller() {
        mainButtonWidthConstraint.constant = view.frame.width * 0.6
        mainButtonHeightConstraint.constant = view.frame.height * 0.06
    }
    
    //увеличивает кнопку при тач ап
    func makeMainButtonNormal() {
        mainButtonWidthConstraint.constant = view.frame.width * 0.7
        mainButtonHeightConstraint.constant = view.frame.height * 0.07
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
