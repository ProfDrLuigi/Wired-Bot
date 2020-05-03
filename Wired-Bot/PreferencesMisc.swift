//
//  BotMainWindow.swift
//  Wired-Bot
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import Cocoa
import Foundation

class PreferencesMisc: NSViewController {
    
    
    @IBOutlet weak var avatar: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.IconDropped),
        name: NSNotification.Name(rawValue: "IconDropped"),
        object: nil)
        
        let base64pic = UserDefaults.standard.string(forKey: "Avatar")!
        let decodedData = NSData(base64Encoded: base64pic, options: [])
            if let data = decodedData {
                let decodedimage = NSImage(data: data as Data)
                self.avatar.image = decodedimage
            } else {
                print("error with decodedData")
            }

    }

        @IBAction func fileselect(_ sender: Any) {
        let dialog = NSOpenPanel();
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["png"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let picpath = (path as String)
                UserDefaults.standard.set(picpath, forKey: "IconSrc")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setIcon"), object: nil)
                let base64pic = UserDefaults.standard.string(forKey: "Avatar")!
                let decodedData = NSData(base64Encoded: base64pic, options: [])
                    if let data = decodedData {
                        let decodedimage = NSImage(data: data as Data)
                        self.avatar.image = decodedimage
                    } else {
                        print("error with decodedData")
                    }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    
    
    @IBAction func close(_ sender: Any) {
        self.view.window?.close()
    }
    
    @objc private func IconDropped(notification: NSNotification){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setIcon"), object: nil)
        let base64pic = UserDefaults.standard.string(forKey: "Avatar")!
        let decodedData = NSData(base64Encoded: base64pic, options: [])
            if let data = decodedData {
                let decodedimage = NSImage(data: data as Data)
                self.avatar.image = decodedimage
            } else {
                print("error with decodedData")
            }
        
    }
    
    
   
}
