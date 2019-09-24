//
//  ViewController.swift
//  Quizzler
//
//  Created by Martynas Narijauskas on 9/22/19.
//  Copyright © 2019 Martynas Narijauskas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Place your instance variables here
    let questionBank = QuestionsBank()
    var pressedAnswer : Bool = false
    var questionNumber : Int = 0
    var score : Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionBank.list.shuffle()
        nextQuestion()
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        if(sender.tag == 1){
            pressedAnswer = true
        }
        else{
            pressedAnswer = false
        }
        
        checkAnswer()
        
        questionNumber += 1
        
        nextQuestion()
    }
    
    
    func updateUI() {
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber + 1) / \(questionBank.list.count)"
        let screenSize = view.frame.size.width
        progressBar.frame.size.width = (screenSize / CGFloat(questionBank.list.count)) * CGFloat(questionNumber + 1)
    }

    func nextQuestion() {
        if(questionNumber >= questionBank.list.count){
            let alert = UIAlertController(title: "Congratz your score: \(score)", message: "You have finished the quiz, do you want to restart?", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Restart", style: .default) { (UIAlertAction) in
                self.startOver()
            }
            scoreLabel.text = "\(score)"
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        else{
            questionLabel.text = questionBank.list[questionNumber].text
            updateUI()
        }
    }
    
    func checkAnswer() {
        if(questionBank.list[questionNumber].correctAnswer == pressedAnswer){
            ProgressHUD.showSuccess("Correct!")
            score += 1
        }
        else{
            ProgressHUD.showError("Wrong!")
            score -= 1
        }
    }
    
    
    func startOver() {
        questionNumber = 0
        score = 0
        nextQuestion()
    }

}
