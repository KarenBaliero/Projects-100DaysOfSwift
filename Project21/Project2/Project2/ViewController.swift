//
//  ViewController.swift
//  Project2
//
//  Created by Karen Lima on 09/08/21.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var answeredQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(showScore))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Remind me", style: .plain, target: self, action: #selector(scheduleLocal))
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay")
            } else {
                print("D'oh")
            }
        }
        countries += ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion()
    }
    
    @objc func scheduleLocal(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Let's play a game"
        content.body = "Can you guess all the countries flags?"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        let secondsPerDay: TimeInterval = 86400
        //        var dateComponents = DateComponents()
        //        dateComponents.hour = 10
        //        dateComponents.minute = 30
        
        //let dataTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        for day in 1...7 {
            let dataTrigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsPerDay * Double(day), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: dataTrigger)
            center.add(request)
        }
        
    }
    
    func askQuestion(action: UIAlertAction! = nil){
        if answeredQuestions > 5 {
            title = "Game Over"
            let ac = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: askQuestion))
            
            present(ac, animated: true)
            score = 0
            answeredQuestions = 0
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)
            title =  countries[correctAnswer].uppercased() + " - SCORE: \(score)"
        }
        
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        answeredQuestions+=1
        if sender.tag == correctAnswer{
            score+=1
            askQuestion()
        } else{
            title = "Oops"
            score-=1
            let ac = UIAlertController(title: title, message: "Wrong! That's the flag of \(countries[sender.tag])", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: askQuestion))
            present(ac, animated: true)
            
        }
        
    }
    
    @objc func showScore(){
        let titlePause = "Paused"
        let ac = UIAlertController(title: titlePause, message: "Your current score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    

}

