//
//  InterfaceController.swift
//  FastColors WatchKit Extension
//
//  Created by Radu Albastroiu on 19/12/2019.
//  Copyright © 2019 Radu Albastroiu. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var red: WKInterfaceButton!
    @IBOutlet weak var yellow: WKInterfaceButton!
    @IBOutlet weak var green: WKInterfaceButton!
    @IBOutlet weak var blue: WKInterfaceButton!
    
    var isWatching = true {
        didSet{
            if isWatching {
                setTitle("WATCH!")
            } else {
                setTitle("REPEAT!")
            }
        }
    }
    
    var sequence = [WKInterfaceButton]()
    var sequenceIndex = 0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        startNewGame()
    }
    
    func playNextSequenceItem() {
        guard sequenceIndex < sequence.count else {
            isWatching = false
            sequenceIndex = 0
            return
        }
        
        let button = sequence[sequenceIndex]
        sequenceIndex += 1
        
        // wait a fraction of a second before flashing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            // mark this button as being active
            button.setTitle("+")

            // wait again
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // deactivate the button and flash again
                button.setTitle("")
                self?.playNextSequenceItem()
            }
        }
    }
    
    func addToSequence() {
        let colors: [WKInterfaceButton] = [red, yellow, green, blue]
        
        sequence.append(colors.randomElement()!)
        
        sequenceIndex = 0
        isWatching = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            self.playNextSequenceItem()
        }
    }
    
    func startNewGame() {
        sequence.removeAll()
        addToSequence()
    }
    
    func makeMove(_ color: WKInterfaceButton) {
        // don't let the player touch stuff while in watch mode
        guard isWatching == false else { return }

        if sequence[sequenceIndex] == color {
            // they were correct! Increment the sequence index.
            sequenceIndex += 1

            if sequenceIndex == sequence.count {
                // they made it to the end; add another button to the sequence
                addToSequence()
            }
        } else {
            // they were wrong! End the game.
            let playAgain = WKAlertAction(title: "Play Again", style: .default) {
                self.startNewGame()
            }

            presentAlert(withTitle: "Game over!", message: "You scored \(sequence.count - 1).", preferredStyle: .alert, actions: [playAgain])
        }
    }
    
    @IBAction func redTapped() {
        makeMove(red)
    }
    
    @IBAction func yellowTapped() {
        makeMove(yellow)
    }
    
    @IBAction func greenTapped() {
        makeMove(green)
    }
    
    @IBAction func blueTapped() {
        makeMove(blue)
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
