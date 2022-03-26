//
//  PopOutViewController.swift
//  chooseAssistant
//
//  Created by 方仕賢 on 2022/3/26.
//

import UIKit

class PopOutViewController: UIViewController {
    //title
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var boxImageView: UIImageView!
    
    //result
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDate()
        showTitle()
        // Do any additional setup after loading the view.
    }
    //title
    func showDate(){
        dateLabel.text = dateString
        if needToDisplayDate {
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
    }
    
    func showTitle() {
        titleLabel.text = titleForOtherPage
    }
    
    
    //open the box
    @IBAction func open(_ sender: Any) {
        if resultView.isHidden == false {
            reset()
        }
        shakeTheBox()
        displayResult()
    }
    
    func shakeTheBox(){
        var time: Double = 0
        boxImageView.image = UIImage(named: "box-0")
        let rightTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { rightTimer in
            self.boxImageView.frame = self.boxImageView.frame.offsetBy(dx: 10, dy: 0)
            time += 0.1
            if time >= 1 {
                rightTimer.invalidate()
            }
        }
        let leftTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { leftTimer in
            self.boxImageView.frame = self.boxImageView.frame.offsetBy(dx: -20, dy: 0)
            time += 0.1
            if time >= 1 {
                leftTimer.invalidate()
                self.openTheBox()
            }
        })
    }
    
    func openTheBox(){
        var imageIndex = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.boxImageView.image = UIImage(named: "box-\(imageIndex)")
            imageIndex += 1
            if imageIndex == 2 {
                timer.invalidate()
                self.bounceViewOut()
            }
        }
    }

    
    
    func reset() {
        resultView.isHidden = true
        boxImageView.frame = boxImageView.frame.offsetBy(dx: 0, dy: -150)
        resultView.frame = resultView.frame.offsetBy(dx: 0, dy: 50)
    }
    
    // show result
    func displayResult(){
        let randomIndex = Int.random(in: 0...buttonImages.count-1)
        resultLabel.text = itemNames[randomIndex]
        resultImageView.image = imageButtons[randomIndex].currentImage!
    }
    
    func bounceViewOut(){
        _ = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { _ in
            let upAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
                _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { _ in
                    let animator = UIViewPropertyAnimator(duration: 0.8, curve: .easeOut) {
                        self.resultView.isHidden = false
                    }
                    animator.startAnimation()
                })
                
                self.resultView.frame = self.resultView.frame.offsetBy(dx: 0, dy: -50)
                self.boxImageView.frame = self.boxImageView.frame.offsetBy(dx: 0, dy: 150)
            }
            upAnimator.startAnimation()
            
        })
        
    }
    
}
