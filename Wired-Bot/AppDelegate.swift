//
//  AppDelegate.swift
//  lkjsljflksdjflksjd
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Prof. Dr. Luigi. All rights reserved.
//

import Cocoa
import WiredSwift
import ShellOut
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ConnectionDelegate {

    @IBOutlet weak var send_button: NSButton!
    @IBOutlet weak var disconnect_button: NSButton!
    @IBOutlet weak var connect_button: NSButton!

    var connection:Connection?
    
    func connectionDidReceiveMessage(connection: Connection, message: P7Message) {
        // if the calling connection is the one we opened
        if connection == self.connection {
            // if it is a chat message
            if message.name == "wired.chat.say" {
                // if the message contains a string in 'wired.chat.say' field
                if let saidText = message.string(forField: "wired.chat.say") {
                    // the message message starts with 'Hello'
                    if saidText.starts(with: "Hello Bot") {
                        // we auto reply 'Hey'
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        response.addParameter(field: "wired.chat.say", value: "Hey :-)")
                        _ = connection.send(message: response)
                    }
                    if saidText.starts(with: "Go away") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        response.addParameter(field: "wired.chat.say", value: "Moooo :(")
                        _ = connection.send(message: response)
                    }
                    if saidText.starts(with: "/bot uptime") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        do {
                        let output = try shellOut(to: "uptime")
                        response.addParameter(field: "wired.chat.say", value: output)
                        _ = connection.send(message: response)
                        } catch {
                            _ = error as! ShellOutError
                        }
                     }
                     if saidText.starts(with: "/bot date") {
                       let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                       response.addParameter(field: "wired.chat.id", value: UInt32(1))
                       do {
                       let output = try shellOut(to: "date")
                       response.addParameter(field: "wired.chat.say", value: output)
                       _ = connection.send(message: response)
                       } catch {
                           _ = error as! ShellOutError
                       }
                    }
                     if saidText.starts(with: "/bot test") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        response.addParameter(field: "wired.chat.say", value: "blaaaaaa")
                        _ = connection.send(message: response)
                    }
                    if saidText.starts(with: "/bot factme") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        do {
                        let output = try shellOut(to: "curl -is --raw https://api.chucknorris.io/jokes/random | sed 's/.*value\"://g' | tail -n 1 | sed 's/}//g'")
                        response.addParameter(field: "wired.chat.say", value: output)
                        _ = connection.send(message: response)
                        } catch {
                            _ = error as! ShellOutError
                        }
                     }
                }
             }
            if message.name == "wired.chat.user_join" {
               let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
               response.addParameter(field: "wired.chat.id", value: UInt32(1))
               //response.addParameter(field: "wired.chat.say", value: "Hello my friend. :-)")
                response.addParameter(field: "wired.chat.say", value: "Hello my friend. :-)")
                sleep(2)
               _ = connection.send(message: response)
            }
            if message.name == "wired.chat.user_leave" {
               let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
               response.addParameter(field: "wired.chat.id", value: UInt32(1))
               response.addParameter(field: "wired.chat.say", value: "Hope to see you soon again. :(")
               _ = connection.send(message: response)
            }
        }
    }
    
   
    func connectionDidReceiveError(connection: Connection, message: P7Message) {
        print("Error received: \(message)")
    }
    
    func connectionDisconnected(connection: Connection, error: Error?) {
        // if we received a disconnect signal, we clear the local connection reference
        self.connection = nil
    }

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.pressSendbutton),
        name: NSNotification.Name(rawValue: "Sendbutton"),
        object: nil)
 
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.pressConnectbutton),
        name: NSNotification.Name(rawValue: "Connectbutton"),
        object: nil)
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.pressDisconnectbutton),
        name: NSNotification.Name(rawValue: "Disconnectbutton"),
        object: nil)
        
        let nickname_check = UserDefaults.standard.string(forKey: "Nick")
        if nickname_check == nil {
            UserDefaults.standard.set("Wired-Bot", forKey: "Nick")
        }
        let status_check = UserDefaults.standard.string(forKey: "Status")
        if status_check == nil {
            UserDefaults.standard.set("Watching you :-)", forKey: "Status")
        }
        let address_check = UserDefaults.standard.string(forKey: "Address")
        if address_check == nil {
            UserDefaults.standard.set("localhost:4871", forKey: "Address")
        }
        let login_check = UserDefaults.standard.string(forKey: "Login")
        if login_check == nil {
            UserDefaults.standard.set("guest", forKey: "Login")
        }
        let password_check = UserDefaults.standard.string(forKey: "Password")
        if password_check == nil {
            UserDefaults.standard.set("", forKey: "Password")
        }
        let greeting_check = UserDefaults.standard.string(forKey: "Greeting_Text")
        if greeting_check == nil {
            UserDefaults.standard.set("Hi Folx, whazzup? :-)", forKey: "Greeting_Text")
        }
        let goodbye_check = UserDefaults.standard.string(forKey: "Goodbye_Text")
        if goodbye_check == nil {
            UserDefaults.standard.set("See ya Folx!", forKey: "Goodbye_Text")
        }
                
        let spec = P7Spec()

        let get_url = UserDefaults.standard.string(forKey: "Address")!
        let url = Url(withString: "wired://" + get_url )

        let connection = Connection(withSpec: spec, delegate: self)

        let nickname = UserDefaults.standard.string(forKey: "Nick")
        connection.nick = (nickname ?? "")

        let status = UserDefaults.standard.string(forKey: "Status")
        connection.status = (status ?? "")

        if connection.connect(withUrl: url) {
            //let message = P7Message(withName: "wired.send_login", spec: connection.spec)
            //message.addParameter(field: "wired.user.login", value: "admin")
            //message.addParameter(field: "wired.user.password", value: "")
            //_ = connection.send(message: message)
            _ = connection.joinChat(chatID: 1)
            let greeting = UserDefaults.standard.bool(forKey: "Greeting")
            if greeting == true {
                self.connection = connection
                let message2 = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                message2.addParameter(field: "wired.chat.id", value: UInt32(1))
                let chat_text = UserDefaults.standard.string(forKey: "Greeting_Text")
                message2.addParameter(field: "wired.chat.say", value: chat_text)
                _ = connection.send(message: message2)
            }
        } else {
            print(connection.socket.errors)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        let defaults = UserDefaults.standard
        defaults.synchronize()
        let goodbye = UserDefaults.standard.bool(forKey: "Goodbye")
        if goodbye == true {
            if let connection = self.connection {
                if connection.isConnected() {
                    let message = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                    message.addParameter(field: "wired.chat.id", value: UInt32(1))
                    let chat_text = UserDefaults.standard.string(forKey: "Goodbye_Text")
                    message.addParameter(field: "wired.chat.say", value: chat_text)
                    _ = connection.send(message: message)
                }
            }
        }
    }

    
    @objc private func pressSendbutton(notification: NSNotification){
        if let connection = self.connection {
            if connection.isConnected() {
                //Set Nickname
                let message_nick = P7Message(withName: "wired.user.set_nick", spec: connection.spec)
                let nick = UserDefaults.standard.string(forKey: "Nick")
                message_nick.addParameter(field: "wired.user.nick", value: nick)
                _ = connection.send(message: message_nick)
                
                //Set Status
                let message_status = P7Message(withName: "wired.user.set_status", spec: connection.spec)
                let status = UserDefaults.standard.string(forKey: "Status")
                message_status.addParameter(field: "wired.user.status", value: status)
                _ = connection.send(message: message_status)
            }
        }
    }


    @objc private func pressConnectbutton(notification: NSNotification){

        let spec = P7Spec()

        let get_url = UserDefaults.standard.string(forKey: "Address")!
        let url = Url(withString: "wired://" + get_url )

        let connection = Connection(withSpec: spec, delegate: self)

        let nickname = UserDefaults.standard.string(forKey: "Nick")
        connection.nick = (nickname ?? "")

        let status = UserDefaults.standard.string(forKey: "Status")
        connection.status = (status ?? "")

        if connection.connect(withUrl: url) {
            _ = connection.joinChat(chatID: 1)
            let greeting = UserDefaults.standard.bool(forKey: "Greeting")
            if greeting == true {
                self.connection = connection
                let message2 = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                message2.addParameter(field: "wired.chat.id", value: UInt32(1))
                let chat_text = UserDefaults.standard.string(forKey: "Greeting_Text")
                message2.addParameter(field: "wired.chat.say", value: chat_text)
                _ = connection.send(message: message2)
            }
        } else {
            print(connection.socket.errors)
        }

    }
    
    @objc private func pressDisconnectbutton(notification: NSNotification){
    if let connection = self.connection {
        if connection.isConnected() {
            _ = connection.disconnect()
        }
    }
    }

}
