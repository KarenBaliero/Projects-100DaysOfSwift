//
//  ViewController.swift
//  Milestone: Projects 7-9
//
//  Created by Karen Lima on 31/08/21.
//

import UIKit

class ViewController: UIViewController {
    var wordLabel: UILabel!
    var currentHiddenWord: String = "?????" {
        didSet{
            wordLabel.text = "\(currentHiddenWord)"
        }
    }
    var correctWord: String = "HELLO"
    var usedLetters = [String]()
    var submittedLetter: String = ""
    var erros = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnwser))
    }
    
    @objc func promptForAnwser (){
        let ac = UIAlertController(title: "Try letter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.hasLetter(answer: answer)

        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.text = "\(currentHiddenWord)"
        view.addSubview(wordLabel)
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.heightAnchor.constraint(equalToConstant: 44),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func hasLetter(answer: String){
        submittedLetter = answer.uppercased()
        print(submittedLetter.uppercased())
        var newWord = [String]()
        usedLetters.append(String(submittedLetter))
        if correctWord.contains(submittedLetter){
            print("2")
            for letter in correctWord {
                print("3")
                if usedLetters.contains(String(letter)) {
                    print("4")
                    newWord.append(String(letter))
                } else {
                    newWord.append("?")
                }
            }
            print(currentHiddenWord)
            currentHiddenWord = newWord.joined()
        } else {
            erros += 1
        }
        if correctWord == currentHiddenWord{
            let ac = UIAlertController(title: "Congratulations", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try Again", style: .default))
            present(ac, animated: true)
        }
        if erros == 7 {
            let ac = UIAlertController(title: "You lose", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try Again", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    

}

