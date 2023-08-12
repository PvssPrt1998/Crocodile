//
//  MainButton.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.08.2023.
//

import UIKit

protocol MainButtonDelegate: AnyObject {
    func mainButtonTapped(_ button: MainButton)
}

@IBDesignable
class MainButton: UIButton {
    
    weak var delegate: MainButtonDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet var mainButton: UIButton!
    
    //MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    //MARK: - Methods
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        delegate?.mainButtonTapped(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonLayer()
    }
    
    private func setupFromNib() {
        guard let button = loadViewFromNib() else { return }
        self.addSubview(button)
        button.frame = self.bounds
    }
    
    private func loadViewFromNib() -> UIButton? {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIButton
    }
    
    private func buttonLayer() {
        mainButton.layer.shadowColor = UIColor.black.cgColor
        mainButton.layer.shadowOpacity = 0.5
        mainButton.layer.shadowOffset = .zero
        mainButton.layer.shadowRadius = 3
        mainButton.layer.masksToBounds = false
        mainButton.layer.cornerRadius = mainButton.bounds.width / 20
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        mainButton.setTitle(title, for: state)
    }
    
    func hide() {
        mainButton.isEnabled = false
        mainButton.layer.opacity = 0.0
    }
    
    func makeVisible() {
        mainButton.isEnabled = true
        animateMainButton(opacity: 1.0, with: 0.2)
    }
    
    func makeInvisible() {
        animateMainButton(opacity: 0.0, with: 0.2)
        mainButton.isEnabled = false
    }
    
    //Метод с анимацией появления mainButton либо сокрытия
    private func animateMainButton(opacity: Float, with duration: CGFloat) {
        UIView.animate(withDuration: duration) {  [] in
            //меняем прозрачность
            self.mainButton.layer.opacity = opacity
        }
    }
}
