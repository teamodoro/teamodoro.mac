//
//  Configuration.swift
//  Teamodoro
//
//  Created by Коньшин Алексей on 22.01.15.
//  Copyright (c) 2015 Коньшин Алексей. All rights reserved.
//

import Cocoa

enum ItemType: NSNumber {
    case Dial = 0
    case Icon = 1
}

class Configuration: NSObject {
    class var mainItemType: ItemType {
        get {
            if let cachedNumber = NSUserDefaults.standardUserDefaults().valueForKey("mainItemType") as? NSNumber {
                if let type = ItemType(rawValue: cachedNumber) {
                    return type
                }
            }
            return .Dial
        }
        set {
            let number = newValue.rawValue
            NSUserDefaults.standardUserDefaults().setValue(number, forKey: "mainItemType")
        }
    }
}
