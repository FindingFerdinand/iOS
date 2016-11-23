//
//  TrendingDetailViewController.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/14/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TrendingDetailViewController: UIViewController {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var breakdownLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var savedLabel: UILabel!

    var trend: Trend!
    
    override func viewDidLoad() {
        navigationItem.titleView = Tools.getNavImage()
        super.viewDidLoad()
        colorView.backgroundColor = trend.uiColor
        colorView.layer.cornerRadius = 45
        nameLabel.text = trend.name
        descriptionText.text = trend.description
        breakdownLabel.text = trend.breakdown
        loadImage()
    }
    
    func loadImage() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        trend.fetchImage() { image, error in
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            if let image = image {
                self.imageView.image = image
            }
        }
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    @IBAction func onSave(_ sender: UIButton) {
        let colorSet = ColorSet(name: trend.name, note: "", context: sharedContext)
        for (colorName, percent) in trend.colors {
            let _ = Color(
                name: colorName,
                percent: percent,
                colorSet: colorSet,
                context: sharedContext)
        }
        CoreDataStackManager.sharedInstance().saveContext()
        Tools.flashLabel(savedLabel)
    }
}
