//
//  Commons.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/7/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import UIKit

var ColorDictionary = [
    "Red Fantasy": UIColor(red: 0.8352941176, green: 0.03921568627, blue: 0.2274509804, alpha: 1),
    "Creamy Mauve": UIColor(red: 0.8666666667, green: 0.4509803922, blue: 0.5215686275, alpha: 1),
    "Orange Flare": UIColor(red: 0.9450980392, green: 0.4549019608, blue: 0.2941176471, alpha: 1),
    "Magenta Pop": UIColor(red: 0.8392156863, green: 0.1333333333, blue: 0.5215686275, alpha: 1),
    "Au Naturel": UIColor(red: 0.7568627451, green: 0.5176470588, blue: 0.4745098039, alpha: 1),
    "Cranberry": UIColor(red: 0.7411764706, green: 0.1215686275, blue: 0.368627451, alpha: 1),
    "Orange Sorbet": UIColor(red: 0.8862745098, green: 0.2039215686, blue: 0.1019607843, alpha: 1),
    "Classic Coral": UIColor(red: 0.9019607843, green: 0.2156862745, blue: 0.3058823529, alpha: 1),
    "Mauvelous": UIColor(red: 0.7215686275, green: 0.4509803922, blue: 0.4823529412, alpha: 1),
    "Flaming Fuchsia": UIColor(red: 0.6823529412, green: 0.1490196078, blue: 0.5215686275, alpha: 1),
    "Pink Pizazz": UIColor(red: 0.8274509804, green: 0.2039215686, blue: 0.5019607843, alpha: 1),
    "Bing Cherry": UIColor(red: 0.5529411765, green: 0.05098039216, blue: 0.09803921569, alpha: 1),
    "Nob Hill Red": UIColor(red: 0.7960784314, green: 0.03529411765, blue: 0.1137254902, alpha: 1),
    "Tequila Sunrise": UIColor(red: 0.9333333333, green: 0.168627451, blue: 0.1254901961, alpha: 1),
    "Berry Jam": UIColor(red: 0.4745098039, green: 0.1803921569, blue: 0.3803921569, alpha: 1),
    "Sinful": UIColor(red: 0.4431372549, green: 0.1058823529, blue: 0.137254902, alpha: 1)
]

var ColorArray = Array(ColorDictionary.keys)

var TrendsURL = "https://ferdinand-6b085.firebaseio.com/trends.json"

class Tools {
    static func mixColors(_ mixture: [(UIColor, Int)]) -> UIColor {
        var cTotal = [0.0, 0.0, 0.0]
        var wTotal = 0.0

        for (color, percent) in mixture {
            var rgba = color.rgba()
            let p = Double(percent)
            cTotal[0] += rgba[0] * p
            cTotal[1] += rgba[1] * p
            cTotal[2] += rgba[2] * p
            wTotal = wTotal + p
        }
        for i in 0...2 {
            cTotal[i] = cTotal[i] / wTotal
        }

        return UIColor(
            red: CGFloat(cTotal[0]),
            green: CGFloat(cTotal[1]),
            blue: CGFloat(cTotal[2]),
            alpha: 1.0)
    }
    
    static func getNavImage() -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 18))
        imageView.image = UIImage(named: "navigation")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }

    static func flashLabel(_ label: UIView) {
        UIView.animate(withDuration: 1.0, animations: {
            label.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                label.alpha = 0.0
            }, completion: { _ in
            }) 
        }) 
    }
    
    static func fadeIn(_ view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.alpha = 1.0
        }, completion: { _ in
        }) 
    }

    static func fadeOut(_ view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.alpha = 0.0
        }, completion: { _ in
        }) 
    }
    
    static func encode(_ str: String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
