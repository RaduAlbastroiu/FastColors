//
//  GameController.swift
//  FastColors WatchKit Extension
//
//  Created by Radu Albastroiu on 20/12/2019.
//  Copyright © 2019 Radu Albastroiu. All rights reserved.
//

import WatchKit
import Foundation

class GameController: WKInterfaceController {

    @IBOutlet weak var LeftButton: WKInterfaceButton!
    @IBOutlet weak var RightButton: WKInterfaceButton!
    
    @IBOutlet weak var TopLabel: WKInterfaceLabel!
    @IBOutlet weak var TimerLabel: WKInterfaceLabel!
    
    let colors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.orange, UIColor.yellow, UIColor.purple, UIColor.darkGray, UIColor.white, UIColor.gray]
    let colorNames = [UIColor.red:"Red", UIColor.blue:"Blue", UIColor.green:"Green", UIColor.orange: "Orange", UIColor.yellow: "Yellow", UIColor.purple: "Purple", UIColor.darkGray: "DarkGray", UIColor.white: "White", UIColor.gray: "Gray"]
    var leftColor = UIColor.orange
    var rightColor = UIColor.orange
    var solutionColor = UIColor.orange
    var lastWrongColor = UIColor.orange
    var lastSolutionColor = UIColor.orange
    var wrongColor = UIColor.orange
    var startTime: Double = 0
    var time: Double = 0
    var timer : Timer?
    var score = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        LeftButton.setBackgroundColor(leftColor)
        RightButton.setBackgroundColor(rightColor)
        
        TopLabel.setText("Press any button to start")
        startNewGame()
    }
    
    func startNewGame() {
        
        startTime = Date().timeIntervalSinceReferenceDate
        
        timer = Timer.scheduledTimer(timeInterval: 0.05,
        target: self,
        selector: #selector(self.timerFired(aTimer:)),
        userInfo: nil,
        repeats: true)
        
        generateRound()
    }
    
    @objc func timerFired(aTimer: Timer) {
        //Total time since timer started, in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime

        //The rest of your code goes here

        //Convert the time to a string with 2 decimal places
        let timeString = String(format: "%.2f", time)

        //Display the time string to a label in our view controller
        TimerLabel.setText(timeString)
    }
    
    func generateRound() {
        
        repeat {
        solutionColor = colors.randomElement()!;
        wrongColor = colors.randomElement()!;
        } while(solutionColor == wrongColor ||
            solutionColor == lastSolutionColor ||
            wrongColor == lastSolutionColor ||
            solutionColor == lastWrongColor ||
            wrongColor == lastWrongColor)
        
        lastSolutionColor = solutionColor
        lastWrongColor = wrongColor
        
        TopLabel.setText(colorNames[solutionColor])
        
        if Bool.random() {
            TopLabel.setTextColor(wrongColor)
        } else {
            TopLabel.setTextColor(solutionColor)
        }
    
        if Bool.random() {
            leftColor = solutionColor
            rightColor = wrongColor
        } else {
            rightColor = solutionColor
            leftColor = wrongColor
        }
        
        DispatchQueue.main.async() {
            self.LeftButton.setBackgroundColor(self.leftColor)
            self.RightButton.setBackgroundColor(self.rightColor)
        }
    }
    
    func evalMove(color: UIColor) {
        if color == solutionColor {
            score += 1
            self.generateRound()
        } else {
            let playAgain = WKAlertAction(title: "Play Again", style: .default) {
                self.score = 0
                self.generateRound()
            }
            presentAlert(withTitle: "Game over!", message: "You scored \(self.score).", preferredStyle: .alert, actions: [playAgain])
        }
    }
    
    @IBAction func LeftButtonPressed() {
        evalMove(color: leftColor)
    }
    
    @IBAction func RightButtonPressed() {
        evalMove(color: rightColor)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
