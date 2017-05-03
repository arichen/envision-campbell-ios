//
//  CalendarViewController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/6/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ContentfulDeliveryAPI
import AirshipKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let client : CDAClient! = AppDelegate.shared.client
    var isLoading : Bool = false
    var dataSource : [CDAEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(EventCell.classForCoder(), forCellReuseIdentifier: EventCell.identifier)
        tableView.separatorStyle = .None
        tableView.rowHeight = EventCell.cellHeight
        tableView.backgroundColor = UIColor.clearColor()
        
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Data
    func reloadData() {
        isLoading = true
        self.client.fetchEntriesMatching(
            [
                "content_type" : "event",
                "order" : "-fields.startTime"
            ],
            success: { (response : CDAResponse, array : CDAArray) -> Void in
                self.isLoading = false
                self.dataSource = array.items as! [CDAEntry]
                self.tableView.reloadData()
                
            }, failure: { (response : CDAResponse?, error : NSError) -> Void in
                self.isLoading = false
                self.tableView.reloadData()
                let alert : UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EventCell.identifier, forIndexPath: indexPath) as! EventCell
        
        let item : CDAEntry = dataSource[indexPath.row]
        cell.date = item.fields["startTime"] as? NSDate
        cell.title = item.fields["title"] as? String
        cell.address = item.fields["address"] as? String
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UAirship.shared().analytics.addEvent(UACustomEvent(name: "view_event"))
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("event") as! EventViewController
        vc.eventData = dataSource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: DZNEmptyDataSetSource
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return (isLoading == true) ? NSAttributedString(string: "Loading...") : NSAttributedString(string: "No Events")
    }
    
}