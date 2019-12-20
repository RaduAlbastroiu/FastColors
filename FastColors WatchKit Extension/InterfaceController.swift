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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    @IBAction func redTapped() {
    }
    
    @IBAction func yellowTapped() {
    }
    
    @IBAction func greenTapped() {
    }
    
    @IBAction func blueTapped() {
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
