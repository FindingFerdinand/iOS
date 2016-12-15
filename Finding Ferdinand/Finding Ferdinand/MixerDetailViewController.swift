//
//  MixerDetailController.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/14/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MixerDetailViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var mixView: UIView!
    @IBOutlet weak var mixTable: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!

    var selections: [Int: Int]!
    var name: String!

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    override func viewDidLoad() {
        self.navigationItem.titleView = Tools.getNavImage()
        super.viewDidLoad()
        mixView.layer.cornerRadius = 45
        updateMixColor()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSliderCell") as! ColorSliderCell
        let key = Array(selections.keys)[indexPath.row]
        cell.setSelection(key, percent: selections[key]!, mvc: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.keys.count
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func updatePercent(_ colorId: Int, percent: Int) {
        selections[colorId] = percent
        updateMixColor()
    }
    
    func updateMixColor() {
        var mixList = [(UIColor, Int)]()
        for (colorId, percent) in selections {
            let color = ColorDictionary[ColorArray[colorId]]!
            mixList.append((color, percent))
        }
        let color = Tools.mixColors(mixList)
        mixView.backgroundColor = color
    }

    @IBAction func onSaveTap(_ sender: UIButton) {
        save()
    }
    
    func save() {
        if !checkError() { return }

        let colorSet = ColorSet(name: nameField.text!, note: "", context: sharedContext)
        for (colorId, percent) in selections {
            let _ = Color(
                name: ColorArray[colorId],
                percent: percent,
                colorSet: colorSet,
                context: sharedContext)
        }
        CoreDataStackManager.sharedInstance().saveContext()
        Tools.flashLabel(savedLabel)
        

        let alert = UIAlertController(title: "SAVED!", message: "Select a creamy, matte, or sheer finish when you swipe to buy in the \"Your Colors\" tab.", preferredStyle: UIAlertControllerStyle.alert)
        
        let openColorTab = UIAlertAction(title: "Go to Colors", style: UIAlertActionStyle.default) { _ in
            self.tabBarController?.selectedIndex = 1
        }

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(openColorTab)
        self.present(alert, animated: true, completion: nil)

    }
    
    func checkError() -> Bool {
        if  (nameField.text == "") {
            errorLabel.text = "PLEASE SPECIFY A NAME"
            Tools.flashLabel(errorLabel)
            return false
        }
        return true
    }
    
}

class ColorSliderCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var colorView: CircularView!
    @IBOutlet weak var percentLabel: UILabel!

    var mvc: MixerDetailViewController!
    var colorName: String!
    var colorId: Int!
    
    func setSelection(_ colorId: Int, percent: Int, mvc: MixerDetailViewController) {
        self.colorId = colorId
        self.mvc = mvc
        
        colorName =  ColorArray[colorId]
        label.text = colorName
        percentLabel.text = "\(percent)%"
        colorView.layer.cornerRadius = 35
        colorView.backgroundColor = ColorDictionary[colorName]
        slider.value = Float(percent)
        slider.tintColor = ColorDictionary[colorName]
    }

    @IBAction func onChange(_ sender: UISlider) {
        let percent = min(Int((sender.value) / 10.0), 100) * 10
        percentLabel.text = "\(percent)%"
        mvc.updatePercent(colorId, percent: percent)
    }
}
