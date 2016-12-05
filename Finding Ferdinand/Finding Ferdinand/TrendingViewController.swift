//
//  TrendingViewController.swift
//  Ferdinand
//
//  Created by Ashwin Hamal on 8/7/16.
//  Copyright © 2016 Hamal Labs. All rights reserved.
//

import Foundation
import UIKit

class TrendingViewController: UITableViewController {
    var trends = [Trend]()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = Tools.getNavImage()

        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTrends()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell") as! TrendCell
        cell.setTrend(trends[indexPath.row])
        return cell
    }

    func fetchTrends() {
        startIndicator()
        TrendClient.loadTrends() { err, trends in
            self.stopIndicator()
            if let trends = trends {
                self.trends = trends
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "No Connection", message: "There seems to be a problem with your connection.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func startIndicator() {
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTrendingDetail", sender: trends[indexPath.row])
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTrendingDetail" {
            if let
                detailVC = segue.destination as? TrendingDetailViewController,
                let trend = sender as? Trend {
                detailVC.trend = trend
            }
        }
    }
}

class TrendCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setTrend(_ trend: Trend) {
        nameLabel.text = trend.name
        descriptionLabel.text = trend.description
        colorView.backgroundColor = trend.uiColor
        colorView.layer.cornerRadius = 46
    }
}
