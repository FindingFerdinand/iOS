//
//  MixerViewController.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/7/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import UIKit

class MixerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var mixView: UIView!
    @IBOutlet weak var colorsView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    var selections: [Int: Int]! = [Int: Int]()

    override func viewDidLoad() {
        mixView.layer.cornerRadius = 45
        colorsView.allowsMultipleSelection = true
        setFlowLayout()
        updateVC()
        navigationItem.titleView = Tools.getNavImage()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    func setFlowLayout() {
//        let dim = CGFloat(80.0) // (colorsView.frame.width) / 4.0 - 1.0
//        flowLayout.minimumInteritemSpacing = 0.0
//        flowLayout.minimumLineSpacing = 1.0
//        flowLayout.itemSize = CGSizeMake(dim, dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    // Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MixerColorViewCell", for: indexPath) as! MixerColorViewCell
        let name = ColorArray[indexPath.item]
        let color = ColorDictionary[name]!
        
        
        cell.setCell(name, color: color, selected: selections[indexPath.item] != nil)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MixerColorViewCell
        cell.checkMark.isHidden = false
        selections[indexPath.item] = 100
        updateVC()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MixerColorViewCell
        cell.checkMark.isHidden = true
        selections.removeValue(forKey: indexPath.item)
        updateVC()
    }
    
    func updateVC() {
        let right = selections.count >= 1 && selections.count <= 4
        
        if right {
            var mixList = [(UIColor, Int)]()
            for (i, _) in selections {
                let color = ColorDictionary[ColorArray[i]]!
                mixList.append((color, 100))
            }
            let color = Tools.mixColors(mixList)
            mixView.backgroundColor = color
        }
        mixView.isHidden = !right
        infoLabel.isHidden = right
        nextButton.isHidden = !right
    }

    @IBAction func next(_ sender: UIButton) {
        //"MixerNextScreen"
        performSegue(withIdentifier: "ShowMixerDetail", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMixerDetail" {
            let detailVC = segue.destination as! MixerDetailViewController
            detailVC.selections = self.selections
        }
    }
}

class MixerColorViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var palette: UIView!
    @IBOutlet weak var checkMark: UIImageView!

    func setCell(_ name: String, color: UIColor, selected: Bool) {
        label.text = name
        palette.backgroundColor = color
        checkMark.isHidden = !selected
        palette.layer.cornerRadius = 39
    }
}

class CircularView: UIView {
//    override func awakeFromNib() {
//        self.layer.cornerRadius = 3.0 + (min(self.frame.size.height, self.frame.size.width)) / 4.0
//        self.layer.masksToBounds = true
//    }
}
