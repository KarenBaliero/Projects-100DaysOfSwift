//
//  ViewController.swift
//  Project2
//
//  Created by Karen Lima on 09/08/21.
//

import UIKit

class ViewController: UIViewController {

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
        
        countries += ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion()
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
        //UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4, options: [], animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        },
//        completion: { _ in
//            UIView.animate(withDuration: 0.5,  delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4, options: [], animations: {
//                sender.transform = .identity
//            })
//        })
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = .identity
        },
        completion: { Void in() })

        
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

