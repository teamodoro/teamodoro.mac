//
//  NSColorExtension.swift
//  Teamodoro
//
//  Created by Коньшин Алексей on 22.01.15.
//  Copyright (c) 2015 Коньшин Алексей. All rights reserved.
//

import Cocoa

extension NSColor {
    func reverseColor() -> NSColor {
        let original = self.colorUsingColorSpaceName(NSCalibratedRGBColorSpace)!
        
        let red = original.redComponent
        let green = original.greenComponent
        let blue = original.blueComponent

        return NSColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: self.alphaComponent)
    }
    
    
    class func trayReverseColor() -> NSColor {
        if let defaults = NSUserDefaults.standardUserDefaults().persistentDomainForName(NSGlobalDomain) {
            if let style = defaults["AppleInterfaceStyle"] as? String {
                if style.lowercaseString == "dark" {
                    return NSColor.whiteColor()
                }
            }
        }
        
        return NSColor.blackColor()
    }
}