//
//  SpinWheelViewController.swift
//  chooseAssistant
//
//  Created by 方仕賢 on 2022/3/21.
//

import UIKit

var smallerThan180 = true
var resultImage = UIImage()
var angles = [CGFloat]()
var resultString = ""
var spinningCounts = 0
var dateString = ""

class SpinWheelViewController: UIViewController {
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    let perDegree = CGFloat.pi / 180
    let center = CGPoint(x: 15, y: 250)
    let radius: CGFloat = 200
    var wheelView = WheelView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if needToDisplayDate {
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
        titleLabel.text = titleForOtherPage
        dateLabel.text = dateString
        spinningCounts = 0
        wheelView.frame = CGRect(x: center.x, y: center.y, width: radius*2, height: radius*2)
        view.addSubview(wheelView)
        makeAWheel()
        // Do any additional setup after loading the view.
    }
    
   
    func makeAWheel() {
        var startAngle = 270*perDegree
        var endAngle = perDegree
        let path = UIBezierPath()
        let parts = itemNames.count
        let labelPath = UIBezierPath()
        
        angles.removeAll()
        
        for i in 0...parts-1 {
            endAngle = startAngle+CGFloat(360/parts)*perDegree
            angles.append(endAngle-270*perDegree)
            
            //circle
            path.move(to: CGPoint(x: radius, y: radius))
            path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = UIColor.black.cgColor
            layer.fillColor = UIColor.clear.cgColor
            wheelView.layer.addSublayer(layer)
            
            //label
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            label.text = itemNames[i]
            label.font = UIFont.systemFont(ofSize: 15)
            label.transform = CGAffineTransform(rotationAngle: (0-(CGFloat(90)-angles[0]+270*perDegree)-(CGFloat.pi*2/CGFloat(parts)/2))+(CGFloat.pi*2/CGFloat(parts)*CGFloat(i)))
            
            labelPath.move(to: CGPoint(x: radius, y: radius))
            labelPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius-50, startAngle: startAngle, endAngle: endAngle-CGFloat(360/parts/2)*perDegree, clockwise: true)
            
            let labelLayer = CAShapeLayer()
            labelLayer.path = labelPath.cgPath
            labelLayer.fillColor = UIColor.clear.cgColor
            labelLayer.contents = label
            
            wheelView.layer.addSublayer(labelLayer)
            
            label.center = labelPath.currentPoint
            wheelView.addSubview(label)
            
            startAngle = endAngle
        }
        
        print(Double.pi, Float.pi)
        //resultView.layer.borderColor
    }
    
    func displayResult() {
        resultView.isHidden = false
        view.bringSubviewToFront(self.resultView)
        resultLabel.text = resultString
        resultImageView.image = resultImage
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.resultView.frame = self.resultView.frame.offsetBy(dx: 0, dy: -650)
        }
        animator.startAnimation()
    }
    
    func reset() {
        if resultView.isHidden == false {
            resultView.frame = resultView.frame.offsetBy(dx: 0, dy: 650)
            resultView.isHidden = true
        }
    }
   

    @IBAction func spin(_ sender: Any) {
        reset()
        wheelView.rotateGradually()
        wheelView.showResult()
        spinButton.isEnabled = false
        let _ = Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { _ in
            self.spinButton.isEnabled = true
            self.displayResult()
        }
    }
}

class WheelView: UIView {
    
    var currentValue : Double = 0*Double.pi
    var randomDouble = Double.random(in: Double.pi/180...Double.pi*2)
    
    func rotateGradually() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        randomDouble = Double.random(in: Double.pi/180...Double.pi*2)
        CATransaction.begin()
        
        rotateAnimation.fromValue = currentValue
        currentValue += randomDouble + (10*Double.pi*2)
        rotateAnimation.toValue = currentValue
        
        rotateAnimation.isRemovedOnCompletion = false
        
        rotateAnimation.fillMode = .forwards
        rotateAnimation.duration = 5
        rotateAnimation.repeatCount = 1
        
        rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0.9, 0.4, 1.00)
        self.layer.add(rotateAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    func showResult(){
        var i = 0
    
        spinningCounts += 1
        print(angles)
        
        let degree =  (Double.pi*2)-(currentValue-(10*Double.pi*Double(spinningCounts))).truncatingRemainder(dividingBy: Double.pi*2)
        while degree > angles[i] {
            i+=1
        }
    
        resultString = itemNames[i]
        resultImage = imageButtons[i].currentImage!
    }
    
    
}
