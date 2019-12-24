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
    
    let colors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.orange, UIColor.yellow, UIColor.purple, UIColor.darkGray, UIColor.white, UIColor.cyan]
    let colorNames = [UIColor.red:"Red", UIColor.blue:"Blue", UIColor.green:"Green", UIColor.orange: "Orange", UIColor.yellow: "Yellow", UIColor.purple: "Purple", UIColor.darkGray: "DarkGray", UIColor.white: "White", UIColor.cyan: "Cyan"]
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
    var timeIncrementIndex = 0
    var timeIncrements = [1.5, 1.25, 1.0, 0.9, 0.8, 0.7, 0.65, 0.6, 1, 0.55, 0.5, 0.45, 0.4, 0.35, 0.75, 0.3, 0.25, 0.2, 0.175, 0.15, 0.125, 0.1, 0.075, 0.05, 0.025]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        LeftButton.setBackgroundColor(leftColor)
        RightButton.setBackgroundColor(rightColor)
        
        TopLabel.setText("Press any button to start")
        startNewGame()
    }
    
    func startNewGame() {
        
        score = 0
        timeIncrementIndex = 0
        
        timer?.invalidate()
        startTime = Date().timeIntervalSinceReferenceDate
        startTime += 3
        
        timer = Timer.scheduledTimer(timeInterval: 0.05,
        target: self,
        selector: #selector(self.timerFired(aTimer:)),
        userInfo: nil,
        repeats: true)
        
        generateRound()
    }
    
    @objc func timerFired(aTimer: Timer) {
        time = startTime - Date().timeIntervalSinceReferenceDate
        
        if(time < 0) {
            stopGame(title: "Time's Up!", message: "")
            return
        }

        let timeString = String(format: "%.2f", time)

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
            startTime += timeIncrements[timeIncrementIndex]
            
            if(score % 5 == 0) {
                timeIncrementIndex += 1
            }
            
            self.generateRound()
        } else {
            time = startTime - Date().timeIntervalSinceReferenceDate
            let timeString = String(format: "%.2f", time)
            stopGame(title: "Wrong Color!", message: "")
        }
    }
    
    func stopGame(title: String, message: String) {
        timer?.invalidate()
        let playAgain = WKAlertAction(title: "Play Again", style: .default) {
            self.startNewGame()
        }
        presentAlert(withTitle: title, message: "You scored \(self.score).\n" + message , preferredStyle: .alert, actions: [playAgain])
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
