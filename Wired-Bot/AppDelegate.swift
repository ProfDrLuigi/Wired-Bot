//
//  AppDelegate.swift
//  lkjsljflksdjflksjd
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Prof. Dr. Luigi. All rights reserved.
//

import Cocoa
import WiredSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ConnectionDelegate {
    
    
    func connectionDidReceiveMessage(connection: Connection, message: P7Message) {
        if message.name == "wired.chat.say" {
            if let saidText = message.string(forField: "wired.chat.say") {
                print(saidText)
            }
         }
    }
    
    func connectionDidReceiveError(connection: Connection, message: P7Message) {
        print("Error received")
    }

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let spec = P7Spec()

        // the Wired URL to connect to
        let url = Url(withString: "wired://localhost:4871")

        // init connection
        let connection = Connection(withSpec: spec, delegate: self)
        connection.nick = "Wired-Bot"
        connection.status = "I´m connected (:"

        // perform  connect
        if connection.connect(withUrl: url) {
            print("connected")
            connection.joinChat(chatID: 1)
        } else {
            // not connected
            print(connection.socket.errors)
        }

        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

