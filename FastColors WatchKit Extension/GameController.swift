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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        LeftButton.setBackgroundColor(UIColor(named: "blue")!)
        RightButton.setBackgroundColor(UIColor(named: "red")!)
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
