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
    
    let colors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.orange]
    let colorNames = [UIColor.red:"Red", UIColor.blue:"Blue", UIColor.green:"Green", UIColor.orange: "Orange"]
    var leftColor = UIColor.orange
    var rightColor = UIColor.orange
    var solutionColor = UIColor.orange
    var wrongColor = UIColor.orange
    var score = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        LeftButton.setBackgroundColor(leftColor)
        RightButton.setBackgroundColor(rightColor)
        
        TopLabel.setText("Press any button to start")
        
        generateRound()
    }
    
    func generateRound() {
        
        repeat {
        solutionColor = colors.randomElement()!;
        wrongColor = colors.randomElement()!;
        } while(solutionColor == wrongColor)
        
        TopLabel.setText(colorNames[solutionColor])
        TopLabel.setTextColor(wrongColor)
    
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
