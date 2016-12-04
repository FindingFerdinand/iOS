//
//  SavedViewController.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/7/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SavedViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var colorSets = [ColorSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
            if let cs = fetchedResultsController.fetchedObjects {
                colorSets = cs
            }
        } catch {
            print("Unresolved error \(error)")
            abort()
        }
        navigationItem.titleView = Tools.getNavImage()
        fetchedResultsController.delegate = self
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            let cs = self.fetchedResultsController.object(at: newIndexPath! as IndexPath)
            self.colorSets.insert(cs, at: (newIndexPath?.item)!)
            self.tableView.reloadData()
        case .delete:
            self.colorSets.remove(at: (indexPath?.item)!)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
            tableView.endUpdates()

        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorSets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedColorCell") as! SavedColorCell
        cell.setColorSet(colorSet: colorSets[indexPath.row])
        return cell
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    lazy var fetchedResultsController: NSFetchedResultsController<ColorSet> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ColorSet")
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultsController as! NSFetchedResultsController<ColorSet>
    } ()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? SavedColorCell {
            cell.toggleButtons(option: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("DeSelected")
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? SavedColorCell {
            cell.toggleButtons(option: false)
        }
    }
}

class SavedColorCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mixLabel: UILabel!
    @IBOutlet weak var mixView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    var set: ColorSet?
    
    func setColorSet(colorSet: ColorSet) {
        set = colorSet
        nameLabel.text = colorSet.name
        mixLabel.text = colorSet.breakdown
        mixView.backgroundColor = colorSet.uiColor
        mixView.layer.cornerRadius = 45
        toggleButtons(option: false)
    }
    
    var shown = false
    func toggleButtons(option: Bool) {
        if option == true {
            shown = !shown
        } else { shown = false }
        
        deleteButton.isEnabled = shown
        buyButton.isEnabled = shown
        if (shown) {
            Tools.fadeIn(deleteButton)
            Tools.fadeIn(buyButton)
        } else {
            Tools.fadeOut(deleteButton)
            Tools.fadeOut(buyButton)
        }
    }

    @IBAction func onDelete(sender: AnyObject) {
        if let set = set {
            CoreDataStackManager.sharedInstance().managedObjectContext.delete(set)
            CoreDataStackManager.sharedInstance().saveContext()

        }
    }

    @IBAction func onBuy(sender: AnyObject) {
        //&quantity=1&properties%5BColor+1%5D=Creamy+Mauve+100%25&properties%5BColor+2%5D=Orange+Flare+100%25&properties%5BColor+3%5D=Classic+Coral+100%25&properties%5BColor+Name%5D=Test&properties%5BNotes%5D=123
        
        
        if let set = set {
            var hash = "id=12477972870&quantity=1&" + Tools.encode("properties[Color Name]") + "=" + Tools.encode(set.name)
            for color in set.colors {
                hash = hash + "&" + Tools.encode("properties[\(color.name)]") + "=" + Tools.encode("\(color.percent)%")
            }
            let url = "https://www.findingferdinand.com/pages/redirect#\(hash)"
            print(url)
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
}
