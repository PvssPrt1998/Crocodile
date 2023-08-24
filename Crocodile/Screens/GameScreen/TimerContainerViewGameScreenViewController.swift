//
//  TimerContainerViewGameScreenViewController.swift
//  Crocodile
//
//  Created by Николай Щербаков on 22.08.2023.
//

import UIKit

protocol TimeOutDelegate: AnyObject {
    func timeOut()
}

class TimerContainerViewGameScreenViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    public weak var delegate: TimeOutDelegate?
    
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 10
    var endTime: Date?
    var timer = Timer()
    let timerLineWidth: CGFloat = 15
    let timerLineShadowWidth: CGFloat = 15
    
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    var isTimeOut: Bool = true {
        didSet {
            if oldValue == false && isTimeOut == true {
                delegate?.timeOut()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSublayers()
        setupAnimations()
        timeLabel.text = timeLeft.time
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawBgShape()
        drawTimeLeftShape()
    }
    
    func addSublayers() {
        view.layer.addSublayer(bgShapeLayer)
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
        } else {
            timeLabel.text = "00:00"
            timer.invalidate()
            isTimeOut = true
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        timeLeftShapeLayer.removeAnimation(forKey: "strokeEnd")
    }
    
    func setupAnimations() {
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        strokeIt.isRemovedOnCompletion = true
    }
    
    func addShadow(for layer: CAShapeLayer) {
        let shadowPath = myPath(radiusOffset: timerLineWidth/2)
        let cutout = myPath(radiusOffset: -timerLineWidth/2).reversing()
        shadowPath.append(cutout)
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = timerLineShadowWidth
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func drawBgShape() {
        bgShapeLayer.path = myPath().cgPath
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = timerLineWidth
        addShadow(for: bgShapeLayer)
    }
    
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = myPath().reversing().cgPath
        timeLeftShapeLayer.strokeColor = UIColor.systemOrange.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = timerLineWidth
        timeLeftShapeLayer.lineCap = .round
    }
    
    func myPath(radiusOffset: CGFloat) -> UIBezierPath {
        let width = view.frame.width * 0.5 - timerLineWidth/2 - timerLineShadowWidth
        let height = view.frame.height * 0.5 - timerLineWidth/2 - timerLineShadowWidth
        let radius = min(width, height) + radiusOffset
        let dif = 2
        let startAngle = (-90 - dif).degreesToRadians
        let endAngle = (270 - dif).degreesToRadians
        
        return UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    func myPath() -> UIBezierPath {
        return myPath(radiusOffset: 0)
    }
}

extension TimerContainerViewGameScreenViewController: TimerRunChildViewControllerDelegate {
    
    func runTimer() {
        isTimeOut = false
        stopTimer()
        timeLeft = 10
        timeLabel.text = timeLeft.time
        
        endTime = Date().addingTimeInterval(timeLeft)
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
}

extension TimeInterval {
    var time: String {
        return String(format: "%02d:%02d", Int(self/60), Int(ceil(truncatingRemainder(dividingBy: 60))))
    }
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
