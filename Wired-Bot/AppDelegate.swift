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
    
    func applicationShouldTerminateAfterLastWindowClosed (_
        theApplication: NSApplication) -> Bool {
        return true
    }

    var connection:Connection?
    
    func connectionDidReceiveMessage(connection: Connection, message: P7Message) {
        if connection == self.connection {
            //if message.name == "wired.chat.user_kick" {
              //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil, userInfo: ["name" : connect_button])
            //}
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
                         response.addParameter(field: "wired.chat.say", value: "bla")
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
                    if saidText.starts(with: "/bot posti") {
                       let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                       response.addParameter(field: "wired.chat.id", value: UInt32(1))
                       do {
                       let output = try shellOut(to: "curl -is --raw https://wired.istation.pw/postilon.txt | sort -R | head -n 1")
                       response.addParameter(field: "wired.chat.say", value: output)
                       _ = connection.send(message: response)
                       } catch {
                           _ = error as! ShellOutError
                       }
                    }
                    if saidText.starts(with: "/bot roundhouseme") {
                       let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                       response.addParameter(field: "wired.chat.id", value: UInt32(1))
                       do {
                       let output = try shellOut(to: "curl -is --raw https://wired.istation.pw/chuck.txt | sort -R | head -n 1")
                       response.addParameter(field: "wired.chat.say", value: output)
                       _ = connection.send(message: response)
                       } catch {
                           _ = error as! ShellOutError
                       }
                    }
                }
             }
            if message.name == "wired.chat.user_join" {
                let welcome = UserDefaults.standard.bool(forKey: "WelcomeUsers")
                if welcome == true {
                   let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                   response.addParameter(field: "wired.chat.id", value: UInt32(1))
                   response.addParameter(field: "wired.chat.say", value: "Hello my friend. :-)")
                   sleep(2)
                   _ = connection.send(message: response)
                }
            }
            if message.name == "wired.chat.user_leave" {
               let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
               response.addParameter(field: "wired.chat.id", value: UInt32(1))
               response.addParameter(field: "wired.chat.say", value: "Hope to see you soon again. :(")
               //_ = connection.send(message: response)
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
        
        //UserDefaults.standard.set(false, forKey: "Connected")
 
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.setNick),
        name: NSNotification.Name(rawValue: "setNick"),
        object: nil)
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.setStatus),
        name: NSNotification.Name(rawValue: "setStatus"),
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
        
        let autoconnect = UserDefaults.standard.bool(forKey: "Autoconnect")
        if autoconnect == true {
        
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
                self.connection = connection
                let message2 = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                message2.addParameter(field: "wired.chat.id", value: UInt32(1))
                let chat_text = UserDefaults.standard.string(forKey: "Greeting_Text")
                message2.addParameter(field: "wired.chat.say", value: chat_text)
                let greeting = UserDefaults.standard.bool(forKey: "Greeting")
                if greeting == true {
                    _ = connection.send(message: message2)
                }
                UserDefaults.standard.set(true, forKey: "Connected")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
            } else {
                print(connection.socket.errors)
                connectalert()
            }
        }
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        let defaults = UserDefaults.standard
        defaults.synchronize()
            if let connection = self.connection {
                if connection.isConnected() {
                    let message = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                    message.addParameter(field: "wired.chat.id", value: UInt32(1))
                    let chat_text = UserDefaults.standard.string(forKey: "Goodbye_Text")
                    message.addParameter(field: "wired.chat.say", value: chat_text)
                    let goodbye = UserDefaults.standard.bool(forKey: "Goodbye")
                    if goodbye == true {
                        _ = connection.send(message: message)
                    }
                    UserDefaults.standard.set(false, forKey: "Connected")
            }
        }
    }

    
    @objc private func setNick(notification: NSNotification){
        let defaults = UserDefaults.standard
        defaults.synchronize()
        if let connection = self.connection {
            if connection.isConnected() {
                let message_nick = P7Message(withName: "wired.user.set_nick", spec: connection.spec)
                let nick = UserDefaults.standard.string(forKey: "Nick")
                message_nick.addParameter(field: "wired.user.nick", value: nick)
                _ = connection.send(message: message_nick)
            }
        }
    }
    
    
    @objc private func setStatus(notification: NSNotification){
        let defaults = UserDefaults.standard
        defaults.synchronize()
        if let connection = self.connection {
            if connection.isConnected() {
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
            //let message = P7Message(withName: "wired.send_login", spec: connection.spec)
            //message.addParameter(field: "wired.user.login", value: "admin")
            //message.addParameter(field: "wired.user.password", value: "")
            //_ = connection.send(message: message)
            _ = connection.joinChat(chatID: 1)
            self.connection = connection
            let message2 = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
            message2.addParameter(field: "wired.chat.id", value: UInt32(1))
            let chat_text = UserDefaults.standard.string(forKey: "Greeting_Text")
            message2.addParameter(field: "wired.chat.say", value: chat_text)
            let greeting = UserDefaults.standard.bool(forKey: "Greeting")
            if greeting == true {
                _ = connection.send(message: message2)
            }
            UserDefaults.standard.set(true, forKey: "Connected")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
        } else {
            print(connection.socket.errors)
            connectalert()
        }

    }

    
    @objc private func pressDisconnectbutton(notification: NSNotification){
        if let connection = self.connection {
            if connection.isConnected() {
                _ = connection.disconnect()
                UserDefaults.standard.set(false, forKey: "Connected")
            }
        }
    }

    
    func connectalert (){
        print("conn refused")
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("It is not possible to log on to the server", comment: "")
        alert.informativeText = NSLocalizedString("Maybe it is not running or the access data is wrong!", comment: "")
        alert.alertStyle = .warning
        let Button = NSLocalizedString("Bummer", comment: "")
        alert.addButton(withTitle: Button)
        alert.runModal()
    }
}
