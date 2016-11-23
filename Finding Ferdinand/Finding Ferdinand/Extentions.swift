//
//  extentions.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/13/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func rgba() -> [Double] {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return [Double(r), Double(g), Double(b), Double(a)]
    }
}
