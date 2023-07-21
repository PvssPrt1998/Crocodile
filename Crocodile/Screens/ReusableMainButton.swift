//
//  MainButtonUIView.swift
//  Crocodile
//
//  Created by Николай Щербаков on 21.07.2023.
//

import UIKit

class ReusableMainButton: UIView {
    let nibName = "ReusableMainButton"
    var contentView: UIView?
    
    @IBOutlet weak var button: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = button.bounds.width / 20
        configureButton(with: cornerRadius)
        configureView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    @IBAction func buttonAction(_ sender: UIButton) {
        
    }
    
    public func configureView() {
        layer.backgroundColor = UIColor(rgb: 0x00DF08).cgColor
        layer.cornerRadius = button.layer.cornerRadius
    }
    
    public func configureButton(with cornerRadius: CGFloat) {
        //layer.backgroundColor = UIColor.clear.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.1
        //button.layer.borderColor = backgroundColor
        button.layer.cornerRadius = button.bounds.width / 20
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
