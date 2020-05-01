//
//  BotMainWindow.swift
//  Wired-Bot
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import Cocoa
import Foundation

class RandomGreetings: NSViewController {

    @IBOutlet weak var greeting1: NSTextField!
    @IBOutlet weak var greeting2: NSTextField!
    @IBOutlet weak var greeting3: NSTextField!
    @IBOutlet weak var greeting4: NSTextField!
    @IBOutlet weak var greeting5: NSTextField!
    @IBOutlet weak var greeting6: NSTextField!
    

    override func viewDidLoad() {
        check_greeting1("")
        check_greeting2("")
        check_greeting3("")
        check_greeting4("")
        check_greeting5("")
        check_greeting6("")
    }
    
    @IBAction func check_greeting1(_ sender: Any) {
        let check_greeting1 = UserDefaults.standard.bool(forKey: "GreetingUser_Text_Random_1_deactivated")
        
        if check_greeting1 == true {
            self.greeting1.isEnabled = false
        } else {
            self.greeting1.isEnabled = true
        }
    }

    @IBAction func check_greeting2(_ sender: Any) {
        let check_greeting2 = UserDefaults.standard.bool(forKey: "GreetingUser_Text_Random_2_deactivated")
        
        if check_greeting2 == true {
            self.greeting2.isEnabled = false
        } else {
            self.greeting2.isEnabled = true
        }
    }

    @IBAction func check_greeting3(_ sender: Any) {
        let check_greeting3 = UserDefaults.standard.bool(forKey: "GreetingUser_Text_Random_3_deactivated")
        
        if check_greeting3 == true {
            self.greeting3.isEnabled = false
        } else {
            self.greeting3.isEnabled = true
        }
    }

    @IBAction func check_greeting4(_ sender: Any) {
        let check_greeting4 = UserDefaults.standard.bool(forKey: "GreetingUser_Text_Random_4_deactivated")
        
        if check_greeting4 == true {
            self.greeting4.isEnabled = false
        } else {
            self.greeting4.isEnabled = true
        }
    }
    
    @IBAction func check_greeting5(_ sender: Any) {
        let check_greeting5 = UserDefaults.standard.bool(forKey: "GreetingUser_Text_Random_5_deactivated")
        
        if check_greeting5 == true {
            self.greeting5.isEnabled = false
        } else {
            self.greeting5.isEnabled = true
        }
    }
    
    @IBAction func check_greeting6(_ sender: Any) {
        let check_greeting6 = UserDefaults.standard.bool(forKey: "GreetingUser_Text_Random_6_deactivated")
        
        if check_greeting6 == true {
            self.greeting6.isEnabled = false
        } else {
            self.greeting6.isEnabled = true
        }
    }
    
    
    @IBAction func close_window(_ sender: Any) {
        self.view.window?.close()
    }
    
}
