//
//  BotMainWindow.swift
//  Wired-Bot
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import Cocoa
import Foundation

class Preferences: NSViewController {

    @IBOutlet weak var png_select: NSTextField!

    
    @IBAction func set_nick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setNick"), object: nil)
    }
    
    @IBAction func set_status(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setStatus"), object: nil)
    }

    @IBAction func set_icon(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setIcon"), object: nil)
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
                png_select.stringValue = path
                let picpath = (path as String)
                UserDefaults.standard.set(picpath, forKey: "IconSrc")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setIcon"), object: nil)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    
    @IBAction func emojicons(_ sender: Any) {
        let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x37, keyDown: true);
        event1?.flags = CGEventFlags.maskControl;
        event1?.post(tap: CGEventTapLocation.cghidEventTap);

        let event2 = CGEvent(keyboardEventSource: nil, virtualKey: 0x3B, keyDown: true);
        event2?.flags = CGEventFlags.maskControl;
        event2?.post(tap: CGEventTapLocation.cghidEventTap);
        
        let event3 = CGEvent(keyboardEventSource: nil, virtualKey: 0x31, keyDown: true);
        event3?.flags = CGEventFlags.maskControl;
        event3?.post(tap: CGEventTapLocation.cghidEventTap);
      
        
    }
    
}
