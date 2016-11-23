//
//  ColorSet.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/13/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(ColorSet)

class ColorSet: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var note: String
    @NSManaged var colors: [Color]

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(name: String, note: String, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entity(forEntityName: "ColorSet", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.name = name
        self.note = note
    }
    
    var breakdown: String {
        var r = [String]()
        for color in colors {
            r.append("\(color.name) \(color.percent)% . ")
        }
        if r.count > 2 {
            r.insert("\n", at: 2)
        }
        return r.joined(separator: "")
    }
    
    var uiColor: UIColor {
        var mixture = [(UIColor, Int)]()
        for color in colors {
            if let uicolor = ColorDictionary[color.name] {
                mixture.append( (uicolor, Int(color.percent)) )
            }
        }
        return Tools.mixColors(mixture)
    }
}
