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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let buyRowAction = UITableViewRowAction(style: .default, title: "  Buy     ", handler:{action, indexpath in
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? SavedColorCell {
                tableView.setEditing(false, animated: true)
                self.alertAndBuy(cell: cell)
            }
        })
        buyRowAction.backgroundColor = UIColor(red: 0.90, green: 0.71, blue: 0.65, alpha: 1.0);
        
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Delete", handler:{action, indexpath in
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? SavedColorCell {
                tableView.setEditing(false, animated: true)
                cell.delete()
            }
        })
        deleteRowAction.backgroundColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1)
        return [deleteRowAction, buyRowAction]
    }
    
    func alertAndBuy(cell: SavedColorCell) {
        let alert = UIAlertController(title: "Select A Finish", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let creamy = UIAlertAction(title: "Creamy", style: UIAlertActionStyle.default) { _ in
            self.alertAndBuy2(cell: cell, finish: "Creamy")
        }
        let matte = UIAlertAction(title: "Matte", style: UIAlertActionStyle.default) { _ in
            self.alertAndBuy2(cell: cell, finish: "Matte")
        }
        let sheer = UIAlertAction(title: "Sheer", style: UIAlertActionStyle.default) { _ in
            self.alertAndBuy2(cell: cell, finish: "Sheer")
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(creamy)
        alert.addAction(matte)
        alert.addAction(sheer)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertAndBuy2(cell: SavedColorCell, finish: String) {
        let alert = UIAlertController(title: "Select A Size", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let mini = UIAlertAction(title: "Mini Sample $6", style: UIAlertActionStyle.default) { _ in
            cell.buy(finish: finish, productId: "34060882246")
        }
        let full = UIAlertAction(title: "Full Size $30", style: UIAlertActionStyle.default) { _ in
            cell.buy(finish: finish, productId: (finish == "Sheer" ? "34060995334" : "34060941702"))
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(mini)
        alert.addAction(full)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)

    }
}

class SavedColorCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mixLabel: UILabel!
    @IBOutlet weak var mixView: UIView!
    
    var set: ColorSet?
    
    func setColorSet(colorSet: ColorSet) {
        set = colorSet
        nameLabel.text = colorSet.name
        mixLabel.text = colorSet.breakdown
        mixView.backgroundColor = colorSet.uiColor
        mixView.layer.cornerRadius = 45
    }
    
    func delete() {
        if let set = set {
            CoreDataStackManager.sharedInstance().managedObjectContext.delete(set)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }

    func buy(finish: String, productId: String) {
        if let set = set {
            var hash = "id=\(productId)&quantity=1&" + Tools.encode("properties[Color Name]") + "=" + Tools.encode(set.name)
            var i = 1
            for color in set.colors {
                hash = hash + "&" + Tools.encode("properties[Color \(i)]") + "=" + Tools.encode("\(color.name) \(color.percent)%")
                i = i + 1
            }
            hash = hash  + "&" + Tools.encode("properties[Finish]=\(finish)")
            
            let url = "https://www.findingferdinand.com/pages/redirect#\(hash)"
            print(url)
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
}
