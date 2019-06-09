//
//  ViewController.swift
//  DailyTextReminder
//
//  Created on 2019-06-04.
//  Copyright © 2019 Flamango. All rights reserved.
//

import CoreData
import UIKit
import MessageUI

public let gradient = CAGradientLayer()

//First App -> No MVC architecture
class ViewController: UIViewController, CAAnimationDelegate, MFMessageComposeViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView! //Text to send
    @IBOutlet weak var timeToAlert: UIDatePicker! //Time to send text
    
    //Background variables
    //let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient = 0
    
    let colorOne = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
    let colorTwo = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor
    let colorThree = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.delegate = self
        let message = UserDefaults.standard.object(forKey: "message")
        
        if message != nil {
            textView.text = message as? String
        }
        
        //Removes the keyboard when clicking away.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        createGradientBackGround()
    }

    @IBAction func setTime(_ sender: Any) { //Creates a notification
        let notificationDelegate = NotificationDelegate()
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: timeToAlert.date)
        
        notificationDelegate.scheduleNotification(triggerTime: dateComponents)
    }
    
    @IBAction func sendText(_ sender: Any) { //Button Action
        let composeText = MFMessageComposeViewController()
        composeText.messageComposeDelegate = self
        
        composeText.recipients = ["Add Phone Number"]
        composeText.body = textView.text
        
        self.present(composeText, animated: true, completion: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //restart animation by changing the color set.
        
        if flag {
            gradient.colors = gradientSet[currentGradient]
        }
        
        animateGradient()
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        //animate over 3 seconds.
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
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
        
        //Makes the button more visible
        let grayGradient = CAGradientLayer()
        let colorGray = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.496281036).cgColor
        let colorTransparent = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0).cgColor
        
        let width = self.view.frame.width
        let height = self.view.frame.height / 8
        let y = height * 7
        
        grayGradient.frame = CGRect(x: 0, y: y, width: width, height: height)
        grayGradient.colors = [colorTransparent, colorGray]
        grayGradient.startPoint = CGPoint(x: 0.5, y: 0)
        grayGradient.endPoint = CGPoint(x:0.5, y: 1)
        grayGradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 0)
        self.view.layer.insertSublayer(grayGradient, at: 1)
        animateGradient()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        //Save the text in a struct. (Too small for learning coreData..)
        UserDefaults.standard.set(textView.text, forKey: "message")
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion:  nil)
        //Stops when changing screen?
    }
}
