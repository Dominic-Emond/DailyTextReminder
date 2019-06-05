//
//  ViewController.swift
//  DailyTextReminder
//
//  Created on 2019-06-04.
//  Copyright © 2019 Flamango. All rights reserved.
//

import UIKit
import MessageUI

//First App -> No MVC architecture
class ViewController: UIViewController, CAAnimationDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var textView: UITextView! //Text to send
    @IBOutlet weak var timeToAlert: UIDatePicker! //Time to send text
    
    //Background variables
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient = 0
    
    let colorOne = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
    let colorTwo = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).cgColor
    let colorThree = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createGradientBackGround()
    }

    @IBAction func sendText(_ sender: Any) { //Button Action
        let composeText = MFMessageComposeViewController()
        composeText.messageComposeDelegate = self
        
        composeText.recipients = ["5147467160"]
        composeText.body = textView.text
        
        self.present(composeText, animated: true, completion: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //restart animation by changing the color set.
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        //animate over 3 seconds.
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
    }
    //Function called when the text is sent/cancelled ?
    func createGradientBackGround() {
        
        //Array of Color Array..
        gradientSet.append([colorOne, colorTwo])
        gradientSet.append([colorTwo, colorThree])
        gradientSet.append([colorThree, colorOne])
        
        //Create The gradient base Layer.
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 0)
        animateGradient()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion:  nil)
    }
}
