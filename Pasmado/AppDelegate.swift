//
//  AppDelegate.swift
//  Pasmado
//
//  Created by Коньшин Алексей on 21.01.15.
//  Copyright (c) 2015 Коньшин Алексей. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
//    var mainController = MainController()
    @IBOutlet var menuController: MenuController!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
//        let windowView = self.window.contentView as NSView
//        let view = self.mainController.view
//        
//        view.frame = windowView.bounds
//        view.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | .ViewHeightSizable
//        windowView.addSubview(view)
        
        menuController.setupMenu()

//
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.backgroundColor = UIColor.whiteColor()
//        
//        let vc = MainController(nibName:"MainController", bundle: nil)
//        self.window?.rootViewController = vc
//        
//        self.window?.makeKeyAndVisible()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

